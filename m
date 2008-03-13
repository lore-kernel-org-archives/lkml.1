Return-Path: <linux-kernel-owner+w=401wt.eu-S1754185AbYCMOgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbYCMOgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 10:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbYCMOgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 10:36:42 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:55796 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbYCMOgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 10:36:42 -0400
Date: Thu, 13 Mar 2008 15:36:31 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       Neil Brown <neilb@suse.de>
Subject: Re: Oops in NFSv4 server in 2.6.23.17
Message-ID: <20080313143631.GH27873@ics.muni.cz>
References: <20080312122550.GB8141@ics.muni.cz> <20080312160007.GA10015@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080312160007.GA10015@fieldses.org>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Thu, 13 Mar 2008 15:36:31 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Mar 12, 2008 at 12:00:07PM -0400, J. Bruce Fields wrote:
> In this case it looks like something in the gss context cache is bad.
> 
> I'm not sure what's going on.

I discovered what triggers this bug. If I have default export with secure
option and I try to connect from insecure port, it produces the oops.
If I add insecure option to the export, no oops at all and mount succeeds.

Also, the bug is not triggered by the first attempt but by the second one.

So I guess that from the first attempt there is something inserted into gss
context cache - error occurs (insecure attempt with the secure option), gss
context is removed from the cache as invalid but not completely. And the
second attempt does oops. Sounds reasonable for me. 

Hope this helps to find the bug.

-- 
Luká¹ Hejtmánek
