Return-Path: <linux-kernel-owner+w=401wt.eu-S939870AbYCTANL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939870AbYCTANL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763874AbYCSX2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 19:28:00 -0400
Received: from web36611.mail.mud.yahoo.com ([209.191.85.28]:46309 "HELO
	web36611.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S942839AbYCSX16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 19:27:58 -0400
X-YMail-OSG: 2u6DYykVM1kznQkDmaTcB2dm9uQlwGU_Voh2A9OhHt1pwt2.eSajDIq0z0YwrCJS5vO1TeD8iH7V4WHrW9NIIqv4Fkhf4rWmLJ1i7PoY5e3Khn1tSmo0amV5QOYoFK775zo_H7DiQU1T2FFxzf5oaA--
X-RocketYMMF: rancidfat
Date: Wed, 19 Mar 2008 16:27:56 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH BUGFIX -rc5] Smack: Do not dereference NULL ipc object
To: "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Casey Schaufler <casey@schaufler-ca.com>,
       akpm <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080314231034.GA1701@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <702478.11090.qm@web36611.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Ahmed S. Darwish" <darwish.07@gmail.com> wrote:

> Hi all,
> 
> In the SYSV ipc msgctl(),semctl(),shmctl() family, if the user passed
> *_INFO as the desired operation, no specific object is meant to be 
> controlled and only system-wide information is returned. This leads
> to a NULL IPC object in the LSM hooks if the _INFO flag is given.
> 
> Avoid dereferencing this NULL pointer in Smack ipc *ctl() methods.
> 
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>

Acked-by: Casey Schaufler <casey@schaufler-ca.com>

Sorry, somehow I thought I'd acked this some time ago.

> ---
> 
>  smack_lsm.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 0241fd3..38d7075 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -1508,7 +1508,7 @@ static int smack_shm_associate(struct shmid_kernel
> *shp, int shmflg)
>   */
>  static int smack_shm_shmctl(struct shmid_kernel *shp, int cmd)
>  {
> -	char *ssp = smack_of_shm(shp);
> +	char *ssp;
>  	int may;
>  
>  	switch (cmd) {
> @@ -1532,6 +1532,7 @@ static int smack_shm_shmctl(struct shmid_kernel *shp,
> int cmd)
>  		return -EINVAL;
>  	}
>  
> +	ssp = smack_of_shm(shp);
>  	return smk_curacc(ssp, may);
>  }
>  
> @@ -1616,7 +1617,7 @@ static int smack_sem_associate(struct sem_array *sma,
> int semflg)
>   */
>  static int smack_sem_semctl(struct sem_array *sma, int cmd)
>  {
> -	char *ssp = smack_of_sem(sma);
> +	char *ssp;
>  	int may;
>  
>  	switch (cmd) {
> @@ -1645,6 +1646,7 @@ static int smack_sem_semctl(struct sem_array *sma, int
> cmd)
>  		return -EINVAL;
>  	}
>  
> +	ssp = smack_of_sem(sma);
>  	return smk_curacc(ssp, may);
>  }
>  
> @@ -1730,7 +1732,7 @@ static int smack_msg_queue_associate(struct msg_queue
> *msq, int msqflg)
>   */
>  static int smack_msg_queue_msgctl(struct msg_queue *msq, int cmd)
>  {
> -	char *msp = smack_of_msq(msq);
> +	char *msp;
>  	int may;
>  
>  	switch (cmd) {
> @@ -1752,6 +1754,7 @@ static int smack_msg_queue_msgctl(struct msg_queue
> *msq, int cmd)
>  		return -EINVAL;
>  	}
>  
> +	msp = smack_of_msq(msq);
>  	return smk_curacc(msp, may);
>  }
>  
> Regards,
> 
> -- 
> 
> "Better to light a candle, than curse the darkness"
> 
> Ahmed S. Darwish
> Homepage: http://darwish.07.googlepages.com
> Blog: http://darwish-07.blogspot.com
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 


Casey Schaufler
casey@schaufler-ca.com
