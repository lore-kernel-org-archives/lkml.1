Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbYIQBZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbYIQBZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 21:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbYIQBY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 21:24:59 -0400
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:33201 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752524AbYIQBY6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 21:24:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=oUP+yB53KBAPM3taboIn+CO4HvFTfWOrc5/zYco5Ro4kQ52vJO26HgBmsRXG0Q8cFBtnX9yyqrM9cA0DRcdOGFKHDmkG5TmZQSF55YbYuI77eD5t1U7dhXpQtNZwFfw48NEXOfvyRrhMe9RywQKfVnxXBYZK6UIk+ZjSMFuyAgw=  ;
X-YMail-OSG: QxchsIMVM1kxNKpkMtbPciUHAgsQPGuMm9PEu_Rk8tzlo6C_qwVzKngs3yZ4v3QOuqyUAdyweakcEDthFfX4gqnrMNI_hZkC3c_vcXtFT1YN6VSyEgrbitfrS0J8P.OHoe5npOgTnl.Lv0D46DRNZWnTHsGUFdj1_v3Y9gpZwM89e_X0guDO
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Michael Trimarchi <trimarchimichael@yahoo.it>
Subject: Re: [PATCH] VFS: make file->f_pos access atomic on 32bit arch
Date: Wed, 17 Sep 2008 11:24:14 +1000
User-Agent: KMail/1.9.5
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <84867.22024.qm@web26206.mail.ukl.yahoo.com>
In-Reply-To: <84867.22024.qm@web26206.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200809171124.14518.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 September 2008 00:57, Michael Trimarchi wrote:
> Hi,
>
> ----- Messaggio originale -----
>
> > Da: Nick Piggin <nickpiggin@yahoo.com.au>
> > A: Michael Trimarchi <trimarchimichael@yahoo.it>
>
> Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>;
> akpm@linux-foundation.org; linux-kernel@vger.kernel.org;
> linux-fsdevel@vger.kernel.org
>
> > Inviato: Martedì 16 settembre 2008, 16:11:21
> > Oggetto: Re: [PATCH] VFS: make file->f_pos access atomic on 32bit arch
>
> ...
>
> > >  i was thinking about introducing a file_pos_update() not implemented
> > > using file_pos_read()/file_pos_write() and taking the seq_lock or
> > > disabling preemption only one time
> >
> > AFAIK, the only way to do an atomic 64 bit store on 32-bit x86 is
> > "cmpxchg8b" (with lock prefix on SMP). That would be far slower
> > I'm sure.
>
> Maybe it is clear with an example:

I understand and agree.
