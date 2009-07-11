Return-Path: <linux-kernel-owner+w=401wt.eu-S1758245AbZGKAtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245AbZGKAtk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 20:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757481AbZGKAtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 20:49:31 -0400
Received: from smtp124.mail.mud.yahoo.com ([209.191.84.227]:25764 "HELO
	smtp124.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757429AbZGKAtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 20:49:31 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Jul 2009 20:49:30 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.ar;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=WPBCeowm/FDgycs/rm8C7JXiQ3clCWT6R9VurNRi94zz7XSEGG2JW+Ec/j0JCJgfjF3O4sz6a/XFtclNQqHdiPGE6+I1Lgc9zU8zm/xlRneGqXNyB8ZXgJphnFSO3WL4J57cuMBtDM25UHtiRlza2iVbxZ3iEuLG6gixpXfkxoY=  ;
X-Yahoo-SMTP: MJlmAJmswBD1ci8cgZcdLoLtCohJxg8-
X-YMail-OSG: J1.4Qc8VM1nONNTcv15mM14COW6rrGaNjQY6yn9.TvsVzR3qHCnPZfic7Q7UkAsJiegqrqrqwd7p9ss_vY7kx7HwmuUBtZdULNFTgCi.T67KAFUYyyqszq30KCubddeGeS4Ie2_WeKAUC2CaxI4Ie3BM9E1.MgvzuC7X.OlSDMvZnWplxB6aJ2m1f7Q8jlgRtB67ookEJU46meTUioRea.FsCN_6tkH1vRR1HwW9RoBvUboQKXwk5yeUrCoZ9UCieRM6u14tLF1QP32ZHOHYXwoIIFNMSCiDYr3bk5LClIrLcSHKyiZaG81PZi_tmKwVCuJ81DcrD9mnTfSJQKGlBJarVsmyh7VKWF4-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4A57DFE2.7020309@yahoo.com.ar>
Date: Fri, 10 Jul 2009 21:42:10 -0300
From: Gerardo Exequiel Pozzi <vmlinuz386@yahoo.com.ar>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: No more vcs1 and vcsa1 in 2.6.30.N
References: <4A57A62C.2030302@yahoo.com.ar> <1247271564.32205.2.camel@yio.site>
In-Reply-To: <1247271564.32205.2.camel@yio.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On Fri, 2009-07-10 at 17:35 -0300, Gerardo Exequiel Pozzi wrote:
>   
>> Since upgrade my system to 2.6.30[.1]. I don't have anymore
>> /sys/devices/virtual/vc/vcs1 and /sys/devices/virtual/vc/vcs1 in
>> consequence not have anymore the corresponding char devs in /dev.
>>     
>
> Seems we missed the consoles, which are always pre-allocated, and not
> created on demand. Does this help?
>
> Thanks,
> Kay
>
> diff --git a/drivers/char/vc_screen.c b/drivers/char/vc_screen.c
> index d94d25c..c1791a6 100644
> --- a/drivers/char/vc_screen.c
> +++ b/drivers/char/vc_screen.c
> @@ -495,11 +495,15 @@ void vcs_remove_sysfs(int index)
>  
>  int __init vcs_init(void)
>  {
> +	unsigned int i;
> +
>  	if (register_chrdev(VCS_MAJOR, "vcs", &vcs_fops))
>  		panic("unable to get major %d for vcs device", VCS_MAJOR);
>  	vc_class = class_create(THIS_MODULE, "vc");
>  
>  	device_create(vc_class, NULL, MKDEV(VCS_MAJOR, 0), NULL, "vcs");
>  	device_create(vc_class, NULL, MKDEV(VCS_MAJOR, 128), NULL, "vcsa");
> +	for (i = 0; i < MIN_NR_CONSOLES; i++)
> +		vcs_make_sysfs(i);
>  	return 0;
>  }
>
>
>
>   
Yes, the problem is solved applying this patch. Thanks for the quick fix
Kay.

Good Luck!

-- 
Gerardo Exequiel Pozzi ( djgera )
http://www.djgera.com.ar
KeyID: 0x1B8C330D
Key fingerprint = 0CAA D5D4 CD85 4434 A219  76ED 39AB 221B 1B8C 330D

