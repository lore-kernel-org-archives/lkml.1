Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbYIPOMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbYIPOMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 10:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbYIPOMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 10:12:08 -0400
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:27154 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751761AbYIPOMH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 10:12:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=gwYUsvyvQrb2+X/hcP0YiQ2PePPmPIA/sSxU5oOiPlM8YUce+9rn0DZucyKCmWB5MjwXM+BtF5TdCH2ijHK0wPeJBIz8Uyga2UWrNikTX/x0PGFTqr4JVOX24yCwpWLorNHYLaAmlJWKVA+GFBitEfv2ZzvA1lqSTWeWVqPZKG8=  ;
X-YMail-OSG: me6WWvEVM1n.g0dlDUvGa_5AgBp1utrojqniYiAkuwmz9mP2ZRI4CiOjwjD69jEeGhCs27jxN1mHTP1kO0dCuww_yKjTh_t04MYjnvwlGfvKr72rj6PX3I9teWcL4kQK8u_unQ0qlNAFXm77rLOUpMtM
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Michael Trimarchi <trimarchimichael@yahoo.it>
Subject: Re: [PATCH] VFS: make file->f_pos access atomic on 32bit arch
Date: Wed, 17 Sep 2008 00:11:21 +1000
User-Agent: KMail/1.9.5
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <476002.75149.qm@web26206.mail.ukl.yahoo.com>
In-Reply-To: <476002.75149.qm@web26206.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200809170011.22062.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 September 2008 23:57, Michael Trimarchi wrote:
> Hi,
>
>
>
> ----- Messaggio originale -----
>
> > Da: Nick Piggin <nickpiggin@yahoo.com.au>
> > A: Michael Trimarchi <trimarchimichael@yahoo.it>
> > Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>;
> > akpm@linux-foundation.org; linux-kernel@vger.kernel.org;
> > linux-fsdevel@vger.kernel.org Inviato: Martedì 16 settembre 2008,
> > 14:54:21
> > Oggetto: Re: [PATCH] VFS: make file->f_pos access atomic on 32bit arch
> >
> > On Tuesday 16 September 2008 21:11, Michael Trimarchi wrote:
> > > Hi,
> > >
> > > > +        if (offset != file_pos_read(file))
> > > > +            file_pos_write(file, offset);
> > > >         retval = offset;
> > > >     }
> > >
> > > Is not more efficient here a compare xchg operation?
> >
> > The compiler should do it if it was.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> > in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
>
>  i was thinking about introducing a file_pos_update() not implemented using
> file_pos_read()/file_pos_write() and taking the seq_lock or
> disabling preemption only one time

AFAIK, the only way to do an atomic 64 bit store on 32-bit x86 is
"cmpxchg8b" (with lock prefix on SMP). That would be far slower
I'm sure.
