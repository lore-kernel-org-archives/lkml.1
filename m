Return-Path: <linux-kernel-owner+w=401wt.eu-S1763438AbXILIW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763438AbXILIW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 04:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbXILIWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 04:22:20 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:21646 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757593AbXILIWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 04:22:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=J084K0qUxRiFu3jUMqVPcfTFJr+oZKB+cjP2zYSS7/khDDpry9d8bN/sMdUFMg8b8T8l2K6j3VwRjcaX6xqg81SJFkyttK5zJaOGcHNiDA9LLibFQ+if3RZIyJ0eBC355Frs8J2Fjzp80qAaYw2fbOs+S/SjMU7ZDlr4z1gdJaQ=
Message-ID: <46E7A1BA.4020805@gmail.com>
Date: Wed, 12 Sep 2007 10:22:18 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jesper Juhl <jesper.juhl@gmail.com>, support@moxa.com.tw,
       Alan Cox <alan@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Moxa: Fix tiny compiler warning when building withoug
 CONFIG_PCI
References: <200708170008.58649.jesper.juhl@gmail.com> <20070911202054.dad2ac0c.akpm@linux-foundation.org>
In-Reply-To: <20070911202054.dad2ac0c.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napsal(a):
> On Fri, 17 Aug 2007 00:08:58 +0200 Jesper Juhl <jesper.juhl@gmail.com> wrote:
> 
>> Fix this tiny compiler warning in Moxa driver : 
>>   drivers/char/mxser.c:386: warning: 'mxser_get_PCI_conf' declared 'static' but never defined
>> when building without CONFIG_PCI.
>>
>>
>> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
>> ---
>>
>>  drivers/char/mxser.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
>> index 2aee3fe..83b15b5 100644
>> --- a/drivers/char/mxser.c
>> +++ b/drivers/char/mxser.c
>> @@ -383,7 +383,9 @@ static int mxser_init(void);
>>  
>>  /* static void   mxser_poll(unsigned long); */
>>  static int mxser_get_ISA_conf(int, struct mxser_hwconf *);
>> +#ifdef CONFIG_PCI
>>  static int mxser_get_PCI_conf(int, int, int, struct mxser_hwconf *);
>> +#endif
>>  static void mxser_do_softint(struct work_struct *);
>>  static int mxser_open(struct tty_struct *, struct file *);
>>  static void mxser_close(struct tty_struct *, struct file *);
>>
> 
> mxser_get_PCI_conf() is defined before it is used anwyay.  So that
> prototype is a stupid waste of space and just adds problems.
> 
> --- a/drivers/char/mxser.c~mxser-fix-compiler-warning-when-building-withoug-config_pci
> +++ a/drivers/char/mxser.c
> @@ -383,7 +383,6 @@ static int mxser_init(void);
>  
>  /* static void   mxser_poll(unsigned long); */
>  static int mxser_get_ISA_conf(int, struct mxser_hwconf *);
> -static int mxser_get_PCI_conf(int, int, int, struct mxser_hwconf *);
>  static void mxser_do_softint(struct work_struct *);
>  static int mxser_open(struct tty_struct *, struct file *);
>  static void mxser_close(struct tty_struct *, struct file *);

Acked-by: Jiri Slaby <jirislaby@gmail.com>

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
