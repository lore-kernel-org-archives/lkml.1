Return-Path: <linux-kernel-owner+w=401wt.eu-S1755009AbYIJTxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbYIJTxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 15:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbYIJTvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 15:51:54 -0400
Received: from atlas.informatik.uni-freiburg.de ([132.230.150.3]:40390 "EHLO
	atlas.informatik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753299AbYIJTvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 15:51:53 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] MAINTAINERS: merge P and M fields to ease copy'n'paste
Date: Wed, 10 Sep 2008 21:51:40 +0200
Message-Id: <1221076300-7018-6-git-send-email-ukleinek@informatik.uni-freiburg.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1221076300-7018-5-git-send-email-ukleinek@informatik.uni-freiburg.de>
References: <20080910193210.GA26173@informatik.uni-freiburg.de>
 <1221076300-7018-1-git-send-email-ukleinek@informatik.uni-freiburg.de>
 <1221076300-7018-2-git-send-email-ukleinek@informatik.uni-freiburg.de>
 <1221076300-7018-3-git-send-email-ukleinek@informatik.uni-freiburg.de>
 <1221076300-7018-4-git-send-email-ukleinek@informatik.uni-freiburg.de>
 <1221076300-7018-5-git-send-email-ukleinek@informatik.uni-freiburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: Universitaet Freiburg, Institut f. Informatik
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was suggested by Sam Ravnborg and done using the following
Python script:

	#! /usr/bin/env python

	import locale
	import re
	import sys
	import tempfile

	locale.setlocale(locale.LC_ALL, 'en_US.UTF-8')

	re_person = re.compile(r'P:(\s*)(.*)')
	re_mail = re.compile(r'M:\s*(.*)')

	fixed_maintainers = tempfile.TemporaryFile()

	current_persons = None
	current_persons_used = False

	for lineno, line in enumerate(open('MAINTAINERS')):
	    mo = re_person.match(line)
	    if mo:
	        if current_persons and not current_persons_used:
	            print >> fixed_maintainers, 'P:%s%s' % (current_persons_intend, ', '.join(current_persons))

	        current_persons = re.split(r',\s*', mo.group(2))
	        current_persons_intend = mo.group(1)
	        current_persons_used = False
	        continue

	    mo = re_mail.match(line)
	    if mo:
	        if current_persons is None:
	            print 'mail without person at line %d' % (lineno + 1)
	            sys.exit(1)

	        mail = re.split(r',\s*', mo.group(1))

	        if mail == ['Mail patches to']:
	            mail = ['p.e@rs.on']

	        if len(mail) != len(current_persons):
	            if len(mail) == 1:
	                current_persons = ['%s' % ', '.join(current_persons)]
	            elif len(current_persons) == 1:
	                current_persons = len(mail) * current_persons
	            else:
	                print 'number of persons doesn\'t match number of mail addresses at line %d' % (lineno + 1)
	                sys.exit(1)

	        print >> fixed_maintainers, 'P:%s' % current_persons_intend + ', '.join('%s <%s>' % pm for pm in zip(current_persons, mail))
	        current_persons_used = True

	    else:
	        if current_persons and not current_persons_used:
	            # either there is no mail address or the entry is already correct
	            print >> fixed_maintainers, 'P:%s%s' % (current_persons_intend, ', '.join(current_persons))

	        current_persons = None
	        print >> fixed_maintainers, line,

	fixed_maintainers.seek(0)

	maintainers = open('MAINTAINERS', 'w')
	for line in fixed_maintainers:
	    print >> maintainers, line,

Signed-off-by: Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 MAINTAINERS | 2363 ++++++++++++++++++++---------------------------------------
 1 files changed, 793 insertions(+), 1570 deletions(-)

I deleted the actual patch to save some bytes.  To get the real patch
you have several possibilities:

 a) look at http://modarm9.com/git/people/ukleinek/linux-2.6.git?a=commit;h=33c64dab660857949c9a78f2a8edca14d30455c5;
 b) fetch/pull from the maintainers branch at

 	 git://www.modarm9.com/gitsrc/pub/people/ukleinek/linux-2.6.git maintainers

    ; or
 c) extract the script above and apply it

Note that a) and b) probably stop working in the future.

Best regards
Uwe
