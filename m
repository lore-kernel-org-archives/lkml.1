Return-Path: <linux-kernel-owner+w=401wt.eu-S1752860AbYLaANs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbYLaANs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 19:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbYLaANk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 19:13:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbYLaANj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 19:13:39 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
X-Fcc: ~/Mail/linus
Cc: oleg@redhat.com, ebiederm@xmission.com, bastian@waldi.eu.org,
       daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6][v5] Define siginfo_from_ancestor_ns()
In-Reply-To: Sukadev Bhattiprolu's message of  Saturday, 27 December 2008 12:52:22 -0800 <20081227205222.GB27337@us.ibm.com>
References: <20081227204658.GA27197@us.ibm.com>
	<20081227205222.GB27337@us.ibm.com>
X-Zippy-Says: If I have enough money to buy 5,000 CANS of NOODLE-RONI, can I get
    a VAT of MARSHMALLOW FLUFF free??
Message-Id: <20081231001255.86B98FC278@magilla.sf.frob.com>
Date: Tue, 30 Dec 2008 16:12:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop the second hunk of the patch (stray whitespace change).

The treatment of SI_ASYNCIO is wrong, as I described in an earlier posting.
(It is indeed a user-generated signal.)  You'll need to avoid using this
function in the path from the USB driver case (interrupt level), since you
can't use SI_ASYNCIO to avoid unsafe use of pid_ns data structures.  If you
do as I suggested in that posting, this is no problem since you just never
do this check in the kill_pid_info_as_uid (perhaps renamed) case.


Thanks,
Roland
