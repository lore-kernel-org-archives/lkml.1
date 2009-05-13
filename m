Return-Path: <linux-kernel-owner+w=401wt.eu-S1761924AbZEMWZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761924AbZEMWZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 18:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbZEMWZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 18:25:36 -0400
Received: from tundra.namei.org ([65.99.196.166]:39717 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbZEMWZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 18:25:35 -0400
Date: Thu, 14 May 2009 08:24:52 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@redhat.com>
cc: debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com,
       m.selhorst@sirrix.com, tpmdd-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TPM: get_event_name stack corruption
In-Reply-To: <20090513165040.16180.77289.stgit@dhcp231-142.rdu.redhat.com>
Message-ID: <alpine.LRH.2.00.0905140824420.26222@tundra.namei.org>
References: <20090513165040.16180.77289.stgit@dhcp231-142.rdu.redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 May 2009, Eric Paris wrote:

> get_event_name uses sprintf to fill a buffer declared on the stack.  It fills
> the buffer 2 bytes at a time.  What the code doesn't take into account is that
> sprintf(buf, "%02x", data) actually writes 3 bytes.  2 bytes for the data and
> then it nul terminates the string.  Since we declare buf to be 40 characters
> long and then we write 40 bytes of data into buf sprintf is going to write 41
> characters.  The fix is to leave room in buf for the nul terminator.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

Applied to 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

> ---
> 
>  drivers/char/tpm/tpm_bios.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_bios.c b/drivers/char/tpm/tpm_bios.c
> index ed306eb..0c2f55a 100644
> --- a/drivers/char/tpm/tpm_bios.c
> +++ b/drivers/char/tpm/tpm_bios.c
> @@ -212,7 +212,8 @@ static int get_event_name(char *dest, struct tcpa_event *event,
>  			unsigned char * event_entry)
>  {
>  	const char *name = "";
> -	char data[40] = "";
> +	/* 41 so there is room for 40 data and 1 nul */
> +	char data[41] = "";
>  	int i, n_len = 0, d_len = 0;
>  	struct tcpa_pc_event *pc_event;
>  
> 

-- 
James Morris
<jmorris@namei.org>
