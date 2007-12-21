Return-Path: <linux-kernel-owner+w=401wt.eu-S1760006AbXLULU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006AbXLULU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 06:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755276AbXLULUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 06:20:49 -0500
Received: from sender-01.it.helsinki.fi ([128.214.205.139]:48108 "EHLO
	sender-01.it.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbXLULUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 06:20:48 -0500
X-Greylist: delayed 1181 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Dec 2007 06:20:48 EST
Message-Id: <200712211101.lBLB15Wk015090@ruuvi.it.helsinki.fi>
Subject: ncpfs unlink() handling question
To: linux-kernel@vger.kernel.org
Date: Fri, 21 Dec 2007 13:01:05 +0200 (EET)
From: Atro Tossavainen <atro.tossavainen@helsinki.fi>
X-Mailer: ELM [version 2.4ME+ PL123]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I've just noticed that ncpfs (or rather, NetWare) doesn't implement
POSIX semantics w.r.t. unlink().  Specifically, any operation that
expects, according to POSIX, that the contents of an open but unlink()ed
file should remain available to the application that has it open, such
as

perl -pi -e 's/a/b/;' a_file

on a ncpfs mounted volume causes the contents of the file to be lost,
as unlink() on ncpfs disposes of the file properly right away and the
new file that is written is a 's/a/b/;' of an empty file, hence another
empty file.

I don't know whether there is any (sensible) way to fix this, but I
would like to initiate a discussion on what would be the correct way
for ncpfs to deal with this.  I just emptied a whole bunch of files
on our web server this way and was rather surprised about it.  Nothing
was lost as the NetWare salvaging mechanism allowed us to rescue every-
thing with a bit of manual labour, and if that hadn't been the case,
we did have it all on tape, but it did catch me off guard... :-)

-- 
Atro Tossavainen (Mr.)               / The Institute of Biotechnology at
Systems Analyst, Techno-Amish &     / the University of Helsinki, Finland,
+358-9-19158939  UNIX Dinosaur     / employs me, but my opinions are my own.
< URL : http : / / www . helsinki . fi / %7E atossava / > NO FILE ATTACHMENTS
