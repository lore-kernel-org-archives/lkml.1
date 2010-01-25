Return-Path: <linux-kernel-owner+w=401wt.eu-S1752794Ab0AYVas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab0AYVas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 16:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466Ab0AYVas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 16:30:48 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37534 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab0AYVar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 16:30:47 -0500
Date: Mon, 25 Jan 2010 21:30:42 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       "Serge E. Hallyn" <serue@linux.vnet.ibm.com>,
       Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [RFC PATCH 1/2] Fix 1 untangling ima mess, part 2 with counters
Message-ID: <20100125213042.GZ19799@ZenIV.linux.org.uk>
References: <cover.1264018123.git.zohar@linux.vnet.ibm.com> <4ad974923eae7a8f52be0786a630b6c64bee9d32.1264018123.git.zohar@linux.vnet.ibm.com> <20100123230735.GW19799@ZenIV.linux.org.uk> <1264447477.3696.30.camel@dyn9002018117.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264447477.3696.30.camel@dyn9002018117.watson.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 02:24:37PM -0500, Mimi Zohar wrote:

> The IMA counters are updated in alloc_file() and __dentry_open().
> __dentry_open() is called from a couple of places:
> lookup_instantiate_filp(), nameidata_to_filp() and dentry_open.  Of
> these calls, files are only being measured in the nameidata_to_filp()
> path.  So yes, the current ima_path_check() needs to be moved to after
> the dentry_open() in nfsd_open(), and also added after each of the other
> dentry_open() and lookup_instantiate_filp() calls.  Otherwise the
> counters will be correct, but the files will not be measured.

Wrong.  lookup_instantiate_filp() is followed by do_filp_open() ones.
So no, we don't need to add there.  As for other dentry_open(), I'm
not at all convinced that we *want* ima_path_check() done for all
of those; it should be decided on per-call basis and it's not a trivial
decision.

