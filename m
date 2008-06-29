Return-Path: <linux-kernel-owner+w=401wt.eu-S1755848AbYF2Q0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbYF2Q0u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 12:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbYF2Q0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 12:26:39 -0400
Received: from hu-out-0506.google.com ([72.14.214.224]:13158 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbYF2Q0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 12:26:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent:from;
        b=uYfYq/lMj/TvUzordYVdqqOmCV2wPRln1eiA4YLZzoqQow0thcTy1oz7uzh3VmKCNz
         ND4Ub9NfO5paRKDTh3+XLz4iPIO42URmowetpCF4KOOG+Qa90VlVKupV+5lksYOaR+3O
         aqdgpjUsZ3/9dXn90QURkQKQMUHteQ3pArYzc=
Date: Sun, 29 Jun 2008 18:26:44 +0200
To: Darren Jenkins <darrenrjenkins@gmail.com>, bzolnier@gmail.com
Cc: kernel Janitors <kernel-janitors@lists.osdl.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       gadio@netvision.net.il
Subject: Re: [PATCH] drivers/ide/ide-tape.c: remove double kfree
Message-ID: <20080629162644.GA10023@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Darren Jenkins <darrenrjenkins@gmail.com>, bzolnier@gmail.com,
	kernel Janitors <kernel-janitors@lists.osdl.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
	gadio@netvision.net.il
References: <1214692474.8254.22.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1214692474.8254.22.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

in case you haven't picked that one up already...

On Sun, Jun 29, 2008 at 08:34:34AM +1000, Darren Jenkins" wrote:
> G'day people,
> 
> 
> Coverity CID: 2336 USE_AFTER_FREE
> 
> drivers/ide/ide-tape.c ide_tape_kfree_buffer() double free's a pointer
> (hint freed by an alias in first outer loop).
> This patch simply removes the superfluous kfree().
> 
> 
> 
> Signed-off-by: Darren Jenkins <darrenrjenkins@gmailcom>
Acked-by: Borislav Petkov <petkovbb@gmail.com>
> 
> 
> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> index 1e1f263..86164be 100644
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c
> @@ -600,7 +600,6 @@ static void ide_tape_kfree_buffer(idetape_tape_t *tape)
>  		bh = bh->b_reqnext;
>  		kfree(prev_bh);
>  	}
> -	kfree(tape->merge_bh);
>  }
>  
>  static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Regards/Gruﬂ,
    Boris.
