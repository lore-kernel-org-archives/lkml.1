Return-Path: <linux-kernel-owner+w=401wt.eu-S1751791AbZLBJBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791AbZLBJBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 04:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751067AbZLBJBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 04:01:21 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:51971 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750927AbZLBJBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 04:01:21 -0500
X-Sasl-enc: LITVqzuLMqRth3/hZTYqh59CCprhdRI9EKoVmqGTiEln 1259744487
Message-ID: <4B162CE4.3080606@imap.cc>
Date: Wed, 02 Dec 2009 10:01:24 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.23) Gecko/20090825 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       isdn@linux-pingi.de, mac@melware.de
Subject: Re: [PATCH] proc_fops: convert drivers/isdn/ to seq_file
References: <20091123015625.GA32088@x200.localdomain> <20091124162541.03e7e375.akpm@linux-foundation.org> <20091125045914.GA3528@x200.malnet.ru> <4B1314F8.10500@imap.cc> <20091130201709.GA4507@x200.malnet.ru>
In-Reply-To: <20091130201709.GA4507@x200.malnet.ru>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Am 2009-11-30 21:17 schrieb Alexey Dobriyan:
> On Mon, Nov 30, 2009 at 01:42:32AM +0100, Tilman Schmidt wrote:
>> Am 25.11.2009 05:59 schrieb Alexey Dobriyan:
>>> --- a/drivers/isdn/gigaset/capi.c
>>> +++ b/drivers/isdn/gigaset/capi.c
>>> @@ -2106,35 +2106,22 @@ static char *gigaset_procinfo(struct capi_ctr *ctr)
>>>  	return ctr->name;	/* ToDo: more? */
>>>  }
>>>  
>>> -/**
>>> - * gigaset_ctr_read_proc() - build controller proc file entry
>>> - * @page:	buffer of PAGE_SIZE bytes for receiving the entry.
>>> - * @start:	unused.
>>> - * @off:	unused.
>>> - * @count:	unused.
>>> - * @eof:	unused.
>>> - * @ctr:	controller descriptor structure.
>>> - *
>>> - * Return value: length of generated entry
>>> - */
>>> -static int gigaset_ctr_read_proc(char *page, char **start, off_t off,
>>> -			  int count, int *eof, struct capi_ctr *ctr)
>>> +static int gigaset_proc_show(struct seq_file *m, void *v)
>> I would prefer that, instead of throwing the kerneldoc comment away,
>> you adapted it to the new function. Specifically, I would like to
>> know what the second argument "void *v" is for.
> 
> Sorry, no.

Ok, if you don't want to do it, I'll wait whether this is merged
and see if I can come up with something sensible as a follow-up.
I guess that's part of the job of a driver maintainer.

>>> +static int gigaset_proc_open(struct inode *inode, struct file *file)
>>> +{
>>> +	return single_open(file, gigaset_proc_show, PDE(inode)->data);
[...]
>> So what is PDE(inode)->data and where does it get set to the
>> capi_ctr pointer for the device?
> 
> When you create proc entry, you set ->data for proc entry,
> it's accessible as PDE(inode)->data.

I see. So in the context of CAPI subsystem - CAPI driver relations,
it's the CAPI subsystem that assures this. You should mention that
in your patch to Documentation/isdn/INTERFACE.CAPI.

Thanks,
Tilman

- --
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Ungeöffnet mindestens haltbar bis: (siehe Rückseite)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFLFizkQ3+did9BuFsRAqOEAJ9hHkwjQoPZUEw1ivKI3J+c2/lgigCgmH0j
Y3t7ifiCcLpr9Gqb8gnNhe4=
=HlV+
-----END PGP SIGNATURE-----
