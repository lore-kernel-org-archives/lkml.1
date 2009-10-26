Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbZJZTVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbZJZTVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbZJZTVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:21:42 -0400
Received: from alto.filmlight.ltd.uk ([77.107.81.250]:23373 "HELO
	a.mx.filmlight.ltd.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755450AbZJZTVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:21:41 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Oct 2009 15:21:41 EDT
Subject: netlink: symantics for NLM_F_MULTI and NLMSG_DONE ?
From: Roger Willcocks <roger@filmlight.ltd.uk>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 26 Oct 2009 19:14:53 +0000
Message-Id: <1256584493.10998.784.camel@montana.filmlight.ltd.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The netlink rfc (3549) says that in multi-part messages (messages split
over multiple netlink packets), the first and all following headers 
have the NLM_F_MULTI flag set except for the last header which has the
header type NLMSG_DONE.

afaict NLMSG_DONE is redundant, since one could simply not set the
NLM_F_MULTI flag for the final header; and if a multi-part message
can't cross a datagram boundary - which is assumed by e.g. the reading
example in
http://www.kernel.org/doc/man-pages/online/pages/man7/netlink.7.html
- NLMSG_DONE is redundant too.

And the rfc doesn't say what NLMSG_DONE /and/ NLM_F_MULTI should mean,
although net/netlink/af_netlink.c always sets both.

So, what are the symantics for NLM_F_MULTI and NLMSG_DONE?



