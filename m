Return-Path: <linux-kernel-owner+w=401wt.eu-S1757036AbZJNHpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbZJNHpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 03:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043AbZJNHpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 03:45:53 -0400
Received: from smtp103.mail.ukl.yahoo.com ([77.238.184.35]:21828 "HELO
	smtp103.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755698AbZJNHpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 03:45:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=ruaY2KF2RWyP6wcD1JVwNZI3vCwqGaHxMZx4jsEn9Zhn3eW8lvqB2rfLjfy927i2PlsnmYDoj5hKa9PQEyhmF7xJRIYndvwzuHOFa7J69Rqg0Arjk8cXBi1kbpzShIhmj8VKd0sip531fbl7mxJi+uUZHJHptgudwnANt4eqDL4=  ;
X-Yahoo-SMTP: dGJefyiswBAq8gjvkVdDD_Aeiz1oX_mV
X-YMail-OSG: VRsB71EVM1l3IKujO6s0gHCBJSJXJJNTvNDquAx98XxW7XynxT4v1i0kcLR74CpvCq9e31HzyzrIYdmhcYSAI2VqjFOOUSg4jiDHMkZGWoA2ZnjFvJU0moHtHLOCY2vr5GhafKI8ZKZl51TI_c9WUarshw3.2hLPdyndOQlddJMS2tin2mmHD6WgJO8.bVCRNxSwq5P3Gfa5V8T..Yf1.u8MLARbyHy3qkHuBnH_zLdaZ5N2JCGFIKagFhYxddSL
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4AD5819B.6000702@yahoo.co.uk>
Date: Wed, 14 Oct 2009 10:45:31 +0300
From: Boyan <btanastasov@yahoo.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.23) Gecko/20090823 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: =?ISO-8859-1?Q?=22Fr=E9d=E9ric_L=2E_W=2E_Meunier=22?= 
	<fredlwm@gmail.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>, Nix <nix@esperi.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Fulghum <paulkf@microgate.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <L6tb-VyKHZK.A.PaB.Ozl0KB@chimera> <C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com> <87ljjgfcbu.fsf@spindle.srvr.nix> <alpine.LFD.2.01.0910121703390.3438@localhost.localdomain> <alpine.LFD.2.01.0910122004200.3438@localhost.localdomain> <4AD3F769.5080405@gmail.com> <alpine.LNX.2.01.0910130405200.9297@dyndns.pervalidus.net> <4AD437F9.9020708@yahoo.co.uk> <alpine.LFD.2.01.0910130745550.3438@localhost.localdomain> <4AD4DE4C.4010402@yahoo.co.uk> <alpine.LFD.2.01.0910131317360.26777@localhost.localdomain> <alpine.LFD.2.01.0910131413240.3596@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0910131413240.3596@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Another bug:
> 
> On Tue, 13 Oct 2009, Linus Torvalds wrote:
>>  			if (!count) {
>> -				if (head->next == NULL)
>> -					break;
> 
> Those two lines should _not_ be deleted. I cleaned up a bit too much.
> 
> The rule is that we must not free the last buffer, because it's also going 
> to be 'tail'.
> 
> So here's a new version with that fixed (and the previous bug I already 
> mentioned).
> 
> Whether it _works_ is still not clear. It might eat your pet goldfish, or 
> make farting noises in your general direction. Or it might fix the bug. 
> Who knows?
> 
> 		Linus
> 
> ---
>  drivers/char/tty_buffer.c |   29 +++++++++++++----------------
>  1 files changed, 13 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/char/tty_buffer.c b/drivers/char/tty_buffer.c
> index 3108991..0296612 100644
> --- a/drivers/char/tty_buffer.c
> +++ b/drivers/char/tty_buffer.c
> @@ -402,28 +402,26 @@ static void flush_to_ldisc(struct work_struct *work)
>  		container_of(work, struct tty_struct, buf.work.work);
>  	unsigned long 	flags;
>  	struct tty_ldisc *disc;
> -	struct tty_buffer *tbuf, *head;
> -	char *char_buf;
> -	unsigned char *flag_buf;
>  
>  	disc = tty_ldisc_ref(tty);
>  	if (disc == NULL)	/*  !TTY_LDISC */
>  		return;
>  
>  	spin_lock_irqsave(&tty->buf.lock, flags);
> -	/* So we know a flush is running */
> -	set_bit(TTY_FLUSHING, &tty->flags);
> -	head = tty->buf.head;
> -	if (head != NULL) {
> -		tty->buf.head = NULL;
> -		for (;;) {
> -			int count = head->commit - head->read;
> +
> +	if (!test_and_set_bit(TTY_FLUSHING, &tty->flags)) {
> +		struct tty_buffer *head;
> +		while ((head = tty->buf.head) != NULL) {
> +			int count;
> +			char *char_buf;
> +			unsigned char *flag_buf;
> +
> +			count = head->commit - head->read;
>  			if (!count) {
>  				if (head->next == NULL)
>  					break;
> -				tbuf = head;
> -				head = head->next;
> -				tty_buffer_free(tty, tbuf);
> +				tty->buf.head = head->next;
> +				tty_buffer_free(tty, head);
>  				continue;
>  			}
>  			/* Ldisc or user is trying to flush the buffers
> @@ -445,9 +443,9 @@ static void flush_to_ldisc(struct work_struct *work)
>  							flag_buf, count);
>  			spin_lock_irqsave(&tty->buf.lock, flags);
>  		}
> -		/* Restore the queue head */
> -		tty->buf.head = head;
> +		clear_bit(TTY_FLUSHING, &tty->flags);
>  	}
> +
>  	/* We may have a deferred request to flush the input buffer,
>  	   if so pull the chain under the lock and empty the queue */
>  	if (test_bit(TTY_FLUSHPENDING, &tty->flags)) {
> @@ -455,7 +453,6 @@ static void flush_to_ldisc(struct work_struct *work)
>  		clear_bit(TTY_FLUSHPENDING, &tty->flags);
>  		wake_up(&tty->read_wait);
>  	}
> -	clear_bit(TTY_FLUSHING, &tty->flags);
>  	spin_unlock_irqrestore(&tty->buf.lock, flags);
>  
>  	tty_ldisc_deref(disc);
> 


It works for me. I couldn't reproduce the problem with this patch on top
of 2.6.31.3 with CONFIG_PREEMPT=y.
