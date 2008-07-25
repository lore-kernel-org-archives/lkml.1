Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbYGYLWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbYGYLWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 07:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbYGYLWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 07:22:37 -0400
Received: from mail51.messagelabs.com ([216.82.244.179]:11745 "EHLO
	mail51.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbYGYLWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 07:22:36 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-2.tower-51.messagelabs.com!1216984955!6894690!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
Date: Fri, 25 Jul 2008 13:22:31 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Jack Howarth <howarth@bromo.msbb.uc.edu>
CC: <linux-kernel@vger.kernel.org>
Subject: git snapshots (Was: Re: merging branches remotely with git?)
Message-ID: <20080725112231.GA28411@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080724224801.GA32241@bromo.msbb.uc.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 25 Jul 2008 11:22:32.0128 (UTC) FILETIME=[BAEE1400:01C8EE48]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> ps Which git represents the git patches (like 2.6.26-git11) which are
> placed as patches on the www.kernel.org web page under the section
> The latest snapshot for the stable Linux kernel tree is:.
AFAIK there is no public tree that contains these tags.  But I have a
little script that creates them.  See below.

Best regards
Uwe


#! /usr/bin/env python

import re
import sys
from urllib2 import urlopen, HTTPError
from subprocess import call

re_version = re.compile('v?(?P<version>2.6.[0-9]+(-rc[0-9]+)?)(?P<snapshot>-git[0-9]+)?')
re_hash = re.compile('[0-9a-f]{40}$')

def get(version):
    url = 'http://kernel.org/pub/linux/kernel/v2.6/snapshots/patch-%s.id' % version
    try:
        f = urlopen(url)
        id = f.read(41).strip()
        print id
        mo = re_hash.match(id)
        if not mo:
            return None

        call(['git', 'tag', '--', 'v%s' % version, id])

    except HTTPError:
        print "could not find %s" % version
        return None

for arg in sys.argv[1:]:
    mo = re_version.match(arg)
    if not mo:
        print 'skip %r' % arg
        continue
    if mo.group('snapshot'):
        get(mo.group('version') + mo.group('snapshot'))

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
