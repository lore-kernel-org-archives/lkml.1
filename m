Return-Path: <linux-kernel-owner+w=401wt.eu-S1758023AbZIFQO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023AbZIFQO5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 12:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757977AbZIFQO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 12:14:56 -0400
Received: from fmmailgate04.web.de ([217.72.192.242]:59816 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757964AbZIFQO4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 12:14:56 -0400
Date: Sun, 06 Sep 2009 18:14:57 +0200
Message-Id: <899959373@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Theodore Tso <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: block_dump - full path ?
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX18H5VV2xsAHaFyll09z3Uj/fWkTApKCmS/2dsE0jdtGoX8yI
 9eOn+g3pCFtmX351NfMcCVOUuwJbTZ7UIHkjvpz5QYA0kREX5I=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

i just (too blindly) copied a tiny part of the log to this mail and kjournald and pdflush are indeed bad examples - sure there is no path for kernel threads.

> What do you mean by "the full path of the process"?  Do you mean the
> full path of the process' executable? 

yes!
certainly this applies to userspace processes only :)

> What exactly are you trying to do? 

determine which processes did read/write.

> There might be a more efficient
> way of gathering whatever data you are trying to get for your experiment.

i think that depends.
if you have a trace of lots of temporary processes doing reads/writes in dmesg, it could be hard to correctly associate a pid with a process-binary /somewhere/deep/inside.
furthermore you can`t assume that binary names are unique on a system.

regards
roland



> On Sat, Sep 05, 2009 at 11:44:35PM +0200, devzero@web.de wrote:
> > Hi, 
> > 
> > i came across the nice debugging feature sysctl vm.block_dump=1 which leaves information on read/write in dmesg for every process.
> > 
> > Sep  5 20:11:15 neoware kernel: kjournald(423): WRITE block 155542512 on sda2
> > Sep  5 20:11:15 neoware kernel: kjournald(423): WRITE block 155542520 on sda2
> > Sep  5 20:11:15 neoware kernel: kjournald(423): WRITE block 155542528 on sda2
> > Sep  5 20:11:19 neoware kernel: pdflush(14): WRITE block 144498288 on sda2
> > Sep  5 20:11:19 neoware kernel: pdflush(14): WRITE block 144916496 on sda2
> > Sep  5 20:11:19 neoware kernel: pdflush(14): WRITE block 144917376 on sda2
> > Sep  5 20:11:19 neoware kernel: pdflush(14): WRITE block 144704600 on sda2
> > 
> > is it possible to log the full path of the process ?
> 
> What do you mean by "the full path of the process"?  Do you mean the
> full path of the process' executable?  (In this case kjournald and
> pdflush are kernel threads so there is no executable, and thus there
> is no "full path". unless you mean pathname to the kernel, i.e., /vmlinux.)
> 
> Or did you mean the full path name of the file associated with the
> block number?  In this case, kjournald is writing to the file system
> journal, which has no pathname.  pdflush is writing dirty pages from
> the page cache, which could be mapped to file names, but it would take
> up a huge amount of space in the log -- but to what effect?
> 
> What exactly are you trying to do?  There might be a more efficient
> way of gathering whatever data you are trying to get for your experiment.
> 
>        		 	       	       - Ted
> 


________________________________________________________________
Neu: WEB.DE Doppel-FLAT mit Internet-Flatrate + Telefon-Flatrate
für nur 19,99 Euro/mtl.!* http://produkte.web.de/go/02/

