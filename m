Return-Path: <linux-kernel-owner+w=401wt.eu-S1753589Ab0AZNDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab0AZNDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 08:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116Ab0AZNDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 08:03:53 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48018 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab0AZNDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 08:03:52 -0500
Date: Tue, 26 Jan 2010 13:03:49 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       "Serge E. Hallyn" <serue@linux.vnet.ibm.com>,
       Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [RFC PATCH 1/2] Fix 1 untangling ima mess, part 2 with counters
Message-ID: <20100126130349.GH19799@ZenIV.linux.org.uk>
References: <cover.1264018123.git.zohar@linux.vnet.ibm.com> <4ad974923eae7a8f52be0786a630b6c64bee9d32.1264018123.git.zohar@linux.vnet.ibm.com> <20100123230735.GW19799@ZenIV.linux.org.uk> <1264447477.3696.30.camel@dyn9002018117.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264447477.3696.30.camel@dyn9002018117.watson.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, this stuff is in for-next, with the following changes:
	* nfsd call has been moved to nfsd_open()
	* patches reordered
	* masking irrelevant bits (i.e. leaving only MAY_{READ,WRITE,EXEC})
has been taken to ima_path_check(); all callers do it and it's safer that
way anyway.

Please, see if it's OK with you in this form; other calls of dentry_open()
are separate story, we'll have to see which ones should and which ones
should not get ima_path_check().  Do you have any other problems with that
one?  If not, it's going to migrate into for-linus and into the mainline;
this stuff is definitely 2.6.33 fodder.
