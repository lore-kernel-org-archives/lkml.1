Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbYIPN6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbYIPN6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 09:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbYIPN55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 09:57:57 -0400
Received: from web26206.mail.ukl.yahoo.com ([217.12.10.243]:22970 "HELO
	web26206.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753603AbYIPN54 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 09:57:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=Rg2Irs8kF92sbpK7vW47+6sG189gHhoGKHXjkB5jJVzuXmkEk/IyGzaV0JBWW93ANa2oSrk56Fc1kLL5LdDX3BCq1bImozCaQswnFc9cgcTUY4kK9hJOzbnM35Voho3IhhNvwjHjCkfT8WDvsye8dTNF0pnGzSJ8ukwt4DYeEjQ=;
X-YMail-OSG: OFEONQ4VM1lvkhA05UOlG5qFMtyArymWrZnYi67ktgjLWoZBfHaU6XTitb8iNDLCGtfoI8AQbgRX__5jeomi8uWxuhv_7PWdXEDGgyLrPwWRNLbffunKCfqP5jXszZYyvdXPcCv.eifNmI.b3cI-
X-Mailer: YahooMailRC/1096.28 YahooMailWebService/0.7.218.2
Date: Tue, 16 Sep 2008 13:57:54 +0000 (GMT)
From: Michael Trimarchi <trimarchimichael@yahoo.it>
Subject: Re: [PATCH] VFS: make file->f_pos access atomic on 32bit arch
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <476002.75149.qm@web26206.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,



----- Messaggio originale -----
> Da: Nick Piggin <nickpiggin@yahoo.com.au>
> A: Michael Trimarchi <trimarchimichael@yahoo.it>
> Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>; akpm@linux-foundation.org; linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org
> Inviato: Martedì 16 settembre 2008, 14:54:21
> Oggetto: Re: [PATCH] VFS: make file->f_pos access atomic on 32bit arch
> 
> On Tuesday 16 September 2008 21:11, Michael Trimarchi wrote:
> > Hi,
> >
> > > +        if (offset != file_pos_read(file))
> > > +            file_pos_write(file, offset);
> > >         retval = offset;
> > >     }
> >
> > Is not more efficient here a compare xchg operation?
> 
> The compiler should do it if it was.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

 i was thinking about introducing a file_pos_update() not implemented using 
file_pos_read()/file_pos_write() and taking the seq_lock or 
disabling preemption only one time

__________________________________________________
Do You Yahoo!?
Poco spazio e tanto spam? Yahoo! Mail ti protegge dallo spam e ti da tanto spazio gratuito per i tuoi file e i messaggi 
http://mail.yahoo.it 
