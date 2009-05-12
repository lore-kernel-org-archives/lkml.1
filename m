Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbZELSy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbZELSy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 14:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbZELSyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 14:54:20 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:62655 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751955AbZELSyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 14:54:19 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar0FAJFcCUpMQW1W/2dsb2JhbACBUMw+hAIF
Date: Tue, 12 May 2009 14:54:16 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Bert Wesarg <bert.wesarg@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH urcu] Use pthread_equal() for pthread_t's equality test
Message-ID: <20090512185415.GA22500@Krystal>
References: <1233911220-27912-1-git-send-email-bert.wesarg@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1233911220-27912-1-git-send-email-bert.wesarg@googlemail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:52:56 up 73 days, 15:19,  6 users,  load average: 0.50, 0.29,
	0.22
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Bert Wesarg (bert.wesarg@googlemail.com) wrote:
> Signed-off-by: Bert Wesarg <bert.wesarg@googlemail.com>
> ---
>  urcu.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 

Hi Bert,

I have to ask all userspace RCU committers for permission to move the
code to LGPL. IBM already gave their approval. Is it OK with you wrt to
the patch you posted here ?

Mathieu

> diff --git a/urcu.c b/urcu.c
> index d0d6138..e401d8d 100644
> --- a/urcu.c
> +++ b/urcu.c
> @@ -185,7 +185,7 @@ void urcu_remove_reader(pthread_t id)
>  
>  	assert(reader_data != NULL);
>  	for (index = reader_data; index < reader_data + num_readers; index++) {
> -		if (index->tid == id) {
> +		if (pthread_equal(index->tid, id)) {
>  			memcpy(index, &reader_data[num_readers - 1],
>  				sizeof(struct reader_data));
>  			reader_data[num_readers - 1].tid = 0;
> -- 
> 1.6.1.rc4
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
