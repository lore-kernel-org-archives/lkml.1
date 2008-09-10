Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827AbYIJTxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbYIJTxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 15:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbYIJTvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 15:51:52 -0400
Received: from atlas.informatik.uni-freiburg.de ([132.230.150.3]:40389 "EHLO
	atlas.informatik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752560AbYIJTvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 15:51:51 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: fix alphabetic ordering
Date: Wed, 10 Sep 2008 21:51:39 +0200
Message-Id: <1221076300-7018-5-git-send-email-ukleinek@informatik.uni-freiburg.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1221076300-7018-4-git-send-email-ukleinek@informatik.uni-freiburg.de>
References: <20080910193210.GA26173@informatik.uni-freiburg.de>
 <1221076300-7018-1-git-send-email-ukleinek@informatik.uni-freiburg.de>
 <1221076300-7018-2-git-send-email-ukleinek@informatik.uni-freiburg.de>
 <1221076300-7018-3-git-send-email-ukleinek@informatik.uni-freiburg.de>
 <1221076300-7018-4-git-send-email-ukleinek@informatik.uni-freiburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: Universitaet Freiburg, Institut f. Informatik
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change was done using the following Python script:

	#! /usr/bin/env python

	import locale
	import re
	import sys
	import tempfile

	locale.setlocale(locale.LC_ALL, 'en_US.UTF-8')

	re_start = re.compile('P:')
	re_topic = re.compile('[0-9a-zA-Z][^:]')
	# F is undefined but used
	re_field = re.compile('[PMLWTSF]:')
	re_empty = re.compile('\s*$')

	prologue = True
	current_topic = None
	topic = dict()
	fixed_maintainers = tempfile.TemporaryFile()

	for line in open('MAINTAINERS'):
	    if prologue:
	        print >> fixed_maintainers, line,
	        mo = re_start.match(line)
	        if mo:
	            prologue = False

	        continue

	    mo = re_topic.match(line)
	    if mo:
	        current_topic = line
	        if topic.has_key(current_topic):
	            sys.exit(1)
	        topic[current_topic] = list()
	        continue

	    elif current_topic is None:
	        # rest of prologue
	        print >> fixed_maintainers, line,

	        continue

	    assert not current_topic is None

	    mo = re_field.match(line)
	    if mo:
	        topic[current_topic].append(line)

	    else:
	        mo = re_empty.match(line)
	        if not mo:
	            print >> sys.stderr, 'tralala', current_topic, repr(line)
	            sys.exit(1)

	first = True

	the_rest = 'THE REST\n'
	have_the_rest = False

	# sort case insensitive
	for t, body in sorted(topic.iteritems(), key=lambda i: i[0].upper()):
	    if t == the_rest:
	        have_the_rest = True
	        continue

	    if first:
	        first = False
	    else:
	        print >> fixed_maintainers

	    print >> fixed_maintainers, t,
	    for line in body:
	        print >> fixed_maintainers, line,

	if have_the_rest:
	    print >> fixed_maintainers

	    print >> fixed_maintainers, the_rest,
	    for line in topic[the_rest]:
	        print >> fixed_maintainers, line,

	fixed_maintainers.seek(0)

	maintainers = open('MAINTAINERS', 'w')
	for line in fixed_maintainers:
	    print >> maintainers, line,

Signed-off-by: Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de>
---
 MAINTAINERS | 1250 +++++++++++++++++++++++++++++-----------------------------
 1 files changed, 625 insertions(+), 625 deletions(-)

I deleted the actual patch to save some bytes.  To get the real patch
you have several possibilities:

 a) look at http://modarm9.com/git/people/ukleinek/linux-2.6.git?a=commit;h=7f347bb1e138857fabc059b791cf50240fedd61f;
 b) fetch/pull from the maintainers branch at

 	 git://www.modarm9.com/gitsrc/pub/people/ukleinek/linux-2.6.git maintainers

    ; or
 c) extract the script above and apply it

Note that a) and b) probably stop working in the future.

Best regards
Uwe
