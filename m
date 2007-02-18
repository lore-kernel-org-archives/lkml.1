Return-Path: <linux-kernel-owner+w=401wt.eu-S1750944AbXBRMuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750944AbXBRMuV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 07:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750953AbXBRMuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 07:50:21 -0500
Received: from lazybastard.de ([212.112.238.170]:59373 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbXBRMuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 07:50:20 -0500
Date: Sun, 18 Feb 2007 12:46:18 +0000
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Sorin Faibish <sfaibish@emc.com>
Cc: Bill Davidsen <davidsen@tmr.com>,
       Juan Piernas Canovas <piernas@ditec.um.es>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
Message-ID: <20070218124617.GA3523@lazybastard.org>
References: <Pine.LNX.4.61.0702151910370.19998@ditec.inf.um.es> <20070215200922.GB24643@lazybastard.org> <Pine.LNX.4.61.0702152353060.19998@ditec.inf.um.es> <20070216091321.GA28092@lazybastard.org> <45D642A4.5010009@tmr.com> <20070217151108.GA301@lazybastard.org> <45D7450F.6090309@tmr.com> <20070217183646.GE301@lazybastard.org> <op.tnwuonh3rwwil4@muki-1mj5c5mxes> <20070218055936.GF301@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070218055936.GF301@lazybastard.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe this is a decent approach to deal with the problem.  First some
definitions.  T is the target segment to be cleaned, S is the spare
segment that valid data is written to, O are other segments that contain
indirect blocks I for valid data D in T.

Have two different GC mechanisms to choose between:
1. Regular GC that copies D and I into S.  On average D+I should require
   less space than S can offer.
2. Slow GC only copies D into S.  Indirect blocks get modified in-place
   in O.  This variant requires more seeks due to writing in various O,
   but it guarantees that D always requires less space than S can offer.

Whenever you are running out of spare segments and are in danger of the
deadlock, switch to mechanism 2.  Now your correctness problem is
reduced to a performance problem.

Jörn

-- 
To recognize individual spam features you have to try to get into the
mind of the spammer, and frankly I want to spend as little time inside
the minds of spammers as possible.
-- Paul Graham
