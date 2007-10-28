Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531AbXJ1Rmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbXJ1Rmb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 13:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755851AbXJ1RmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 13:42:15 -0400
Received: from orion2.pixelized.ch ([195.190.190.13]:57785 "EHLO
	mail.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683AbXJ1RmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 13:42:14 -0400
Message-ID: <4724C9E8.3070404@cateee.net>
Date: Sun, 28 Oct 2007 18:42:00 +0100
From: Giacomo Catenazzi <cate@cateee.net>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kbuild devel list <linux-kbuild@vger.kernel.org>
Subject: kernel drivers database (hardware, config, file) and "autoconfiguration"
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've build a python script (consisting on short 4 modules) to
build a hardware database fomr kernel sources, with includes:
type of hardware, hardware information, kernel CONFIG and
the kernel file where such hardware was described.

Actually I can detect nearly 6000 probes (and easily expandable).

The script is writen in pyhon:
$ wc -l *.py
  148 build-drivers-db.py
  819 devicetables.py
  134 kbuildparser.py
  281 srcparser.py
 1382 total

build-drivers-db.py : the main procedures
devicetables.py : the information of structures and fields of probes
kbuildparser.py : a simpler scanner of Makefile for the configuration infos
srcparser.py : a not so simple source parser, macro expander, quite fast


In addition, I've done a short and incomplete shell scripts which detect and
write own hardware information, and a shell script which tell you what
CONFIG_ you should check.


The build-drivers-db part use a lot of euristic to have a sensible
hardware list, but some drivers are "strange", some use non-standard
methods and other have also an hardware blacklist (which the program
take it as a whitelist).

But the script is still usefull, clean, easily expandable and
very fast (near 2 minutes with an hot cache and intermediate
machine for entiere kernel sources)
I expect to correct some deficiencies of the script and to write
clean-up patches where the drivers code is very ugly.


The other two shell scripts are almost incomplete, they need more
care, but now I've done as proof of concept.


I like to receive comments, corrections or simple bug reports.

The scripts are in:
http://www.cateee.net/kernel/kernautoconf/kernautoconf-3.0/
and the driver database is (updated to last git)
http://www.cateee.net/kernel/kernautoconf/kernautoconf-3.0/drivers-db

ciao
	cate


PS: The project was born (IIRC) in 2001, as part of 2.5.x kbuild rewrite.
After rejection of the two other main projects (kbuild and CML2), I
stopped the project, because of lack of an interface.
Latelly I read again the code, and I started to rewrite it, mainly
on the database building problem.

When I'll find the latest old version, I'll put online. On some
part it was more powerfull, but without an automatic creation of driver
database.  The old autoconfiguration had more detection of basic system
configuration (non database based, such CPU, CPU extentions, system drivers,...).
I'll try to import also such parts, but now I'm more interested on building
a nearly complete driver database.

