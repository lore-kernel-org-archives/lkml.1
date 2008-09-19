Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbYISQdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbYISQdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 12:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbYISQdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 12:33:13 -0400
Received: from web26206.mail.ukl.yahoo.com ([217.12.10.243]:26579 "HELO
	web26206.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751294AbYISQdM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 12:33:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=UOwGx7J7ymUvW1UqWqU2TmXkIFVXJ1fyYEKj+ZFs1EBmrzS33pXzBugdde8r49zOVTKRg14HfhYbPqSmtrcqDF++zfO4/iSEPFFFWgzRwDsoDN5zzowPpZDVw9kdiLovpU0ps1mGLzCLZkrHRaNWWzFYpztoD8q1UILJU9KmAvU=;
X-YMail-OSG: AuBSGtMVM1l7VY5w0OfKyeeSBUMtLm4NTQOKfrmzEkgbfsNMwLzTHuzyTiZUBPJoRpzNJ5A9k.7rxkbYY3SRVxOPfmwz8deq9yUegLUUF8rcKO5NmOUmoUL0UdIa0.uSM5xn7HVP.INCw4Yzw0Y-
X-Mailer: YahooMailRC/1096.28 YahooMailWebService/0.7.218.2
Date: Fri, 19 Sep 2008 16:33:09 +0000 (GMT)
From: Michael Trimarchi <trimarchimichael@yahoo.it>
Subject: Re: [PATCH] atmel_serial: update the powersave handler to match serial core
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Victor <linux@maxim.org.za>,
       Anti Sullin <anti.sullin@artecdesign.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <866907.89401.qm@web26206.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,



----- Messaggio originale -----
> Da: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> A: Michael Trimarchi <trimarchimichael@yahoo.it>
> Cc: linux-serial@vger.kernel.org; linux-kernel@vger.kernel.org; Andrew Victor <linux@maxim.org.za>; Anti Sullin <anti.sullin@artecdesign.ee>
> Inviato: Venerdì 19 settembre 2008, 18:15:51
> Oggetto: Re: [PATCH] atmel_serial: update the powersave handler to match serial core
> 

> I agree it would be useful. It would require changing the port mux
> configuration from the driver though, and there's no standardized
> interface for doing that. Maybe this is a good motivation to come up
> with one?
> 

I think that a driver can do the request to a the gpio layer (may can be implemented
by the gpio-lib ) and give it only the gpio. The "gpio-lib" can save and restore
the status of the gpio, and request the handler, passing the gpio-id as 
a data. So when the handler fire, we can now which peripheral is
interested on the wake-up event.

> Btw, I assume the first character you receive will be lost when you do
> this, right?
>

Yes, I haven't done a lot of test to see how many chars are lost (sure one I think). 
Depends on the time spent after

 /* Wait for interrupt to wake us up */ 
  mcr p15, 0, r0, c7, c0, 4 
 
> Haavard

Regards Michael


__________________________________________________
Do You Yahoo!?
Poco spazio e tanto spam? Yahoo! Mail ti protegge dallo spam e ti da tanto spazio gratuito per i tuoi file e i messaggi 
http://mail.yahoo.it 
