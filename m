Return-Path: <linux-kernel-owner+w=401wt.eu-S1755532AbYKNSNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbYKNSNK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 13:13:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbYKNSM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 13:12:57 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57589 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbYKNSM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 13:12:56 -0500
Date: Fri, 14 Nov 2008 16:11:55 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, security@kernel.org,
       Eugene Teo <eteo@redhat.com>, Arjan van de Ven <arjan@infradead.org>
Subject: [GIT PATCHES for 2.6.28] V4L/DVB security fixes (CVE-2008-5033)
Message-ID: <20081114161155.32573d3b@pedra.chehab.org>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

For a series of fixes at tvaudio module motivated by CVE-2008-5033.

This module were written back on 2000 and weren't receiving much 
attention nowadays. The only patches lately were related to API improvements
elsewhere (like V4L2 conversion and I2C changes).

This patch series fixes a memory leak and improves the error handling inside
the driver to reduce the potential risk of security issues, properly fixing
CVE-2008-5033.

It consists of the following patches:
   - tvaudio: fix a memory leak;
   - tvaudio: instead of using a magic number, use ARRAY_SIZE;
   - tvaudio: cleanup - group all callbacks together;
   - tvtime: remove generic_checkmode callback;
   - tvaudio: add additional logic to avoid OOPS;
   - tvaudio: update initial comments;
   - tvaudio: use a direct reference for chip description;
   - Avoid writing outside shadow.bytes[] array;
   - tvaudio: Improve comments and remove a unneeded prototype;
   - tvaudio: Improve debug msg by printing something more human;
   - CVE-2008-5033: fix OOPS on tvaudio when controlling bass/treble.

Cheers,
Mauro.

---

 drivers/media/video/tvaudio.c |  233 ++++++++++++++++++++++++++---------------
 1 files changed, 150 insertions(+), 83 deletions(-)

Mauro Carvalho Chehab (11):
      V4L/DVB (9613): tvaudio: fix a memory leak
      V4L/DVB (9615): tvaudio: instead of using a magic number, use ARRAY_SIZE
      V4L/DVB (9616): tvaudio: cleanup - group all callbacks together
      V4L/DVB (9617): tvtime: remove generic_checkmode callback
      V4L/DVB (9618): tvaudio: add additional logic to avoid OOPS
      V4L/DVB (9619): tvaudio: update initial comments
      V4L/DVB (9620): tvaudio: use a direct reference for chip description
      V4L/DVB (9621): Avoid writing outside shadow.bytes[] array
      V4L/DVB (9622): tvaudio: Improve comments and remove a unneeded prototype
      V4L/DVB (9623): tvaudio: Improve debug msg by printing something more human
      V4L/DVB (9624): CVE-2008-5033: fix OOPS on tvaudio when controlling bass/treble

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
