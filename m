Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbYLCGyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbYLCGyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 01:54:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbYLCGy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 01:54:28 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:36364 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbYLCGy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 01:54:27 -0500
Message-ID: <49362D1E.1000907@davidnewall.com>
Date: Wed, 03 Dec 2008 17:24:22 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Geoffrey McRae <geoff@rabidhost.com>
CC: Peter Teoh <htmldeveloper@gmail.com>, Valdis.Kletnieks@vt.edu,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: New Security Features, Please Comment
References: <1228260494.24232.21.camel@compy.ivent.com.au>	 <20081203005338.6472db7a@lxorguk.ukuu.org.uk>	 <1228268657.6679.4.camel@lappy.spacevs.com>	 <73639.1228272932@turing-police.cc.vt.edu>	 <1228276959.6679.27.camel@lappy.spacevs.com>	 <804dabb00812022035k1876a521qa41cd4634b70f9a2@mail.gmail.com> <1228280545.6679.40.camel@lappy.spacevs.com>
In-Reply-To: <1228280545.6679.40.camel@lappy.spacevs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geoffrey McRae wrote:
> Right now the only forseeable problem is that if a process holds a fd
> open when the parent app changes its uid/gid, which still, the worst
> that it can do is read/write another user's file.

Well,  no, there are more problems than open file descriptors; and the
worst is much worse than reading or writing another user's file. 
Suppose you're changing the ids of the Perl, Python or PHP interpreter:
the first user could install a SIGCLD handler and fork and exec sleep. 
When sleep dies, the handler gets executed as another user - hopefully a
user with access to credit card details, or other financially valuable
information.
