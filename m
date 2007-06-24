Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbXFXQTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbXFXQTE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 12:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755366AbXFXQS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 12:18:57 -0400
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:49283 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256AbXFXQS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 12:18:56 -0400
Date: Sun, 24 Jun 2007 12:18:52 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@localhost.localdomain
To: "Serge E. Hallyn" <serge@hallyn.com>
cc: Andrew Morgan <morgan@kernel.org>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Chris Wright <chrisw@sous-sol.org>, Andrew Morgan <agm@google.com>,
       casey@schaufler-ca.com, Andrew Morton <akpm@google.com>,
       Stephen Smalley <sds@tycho.nsa.gov>,
       linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: implement-file-posix-capabilities.patch
In-Reply-To: <20070624155100.GA5167@vino.hallyn.com>
Message-ID: <Line.LNX.4.64.0706241158320.12660@localhost.localdomain>
References: <20070611123714.GA2063@sergelap.austin.ibm.com>
 <878322.98602.qm@web36606.mail.mud.yahoo.com>
 <afff21250706110926l244ddc28i44289cb08a6721e2@mail.gmail.com>
 <20070617135239.GA17689@sergelap> <4676007F.7060503@kernel.org>
 <20070618044017.GW3723@sequoia.sous-sol.org> <20070620171037.GA28670@sergelap.ibm.com>
 <20070620174613.GF3723@sequoia.sous-sol.org> <20070621160011.GB9913@sergelap.austin.ibm.com>
 <467CD63B.4000703@kernel.org> <20070624155100.GA5167@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jun 2007, Serge E. Hallyn wrote:

> > 2) Allocate capability bit-31 for CAP_SETFCAP, and use it to gate
> > whether the user can set this xattr on a file or not. CAP_SYS_ADMIN is
> > way too overloaded and this functionality is special.
> 
> The functionality is special, but someone with CAP_SYS_ADMIN can always
> unload the capability module and create the security.capability xattr
> using the dummy module.
> 
> If we do add this cap, do we want to make it apply to all security.*
> xattrs?

The underlying issue here is the notion of security mechanisms which are 
built as loadable modules.  It's not useful for any in-tree users, and 
introduces several unnecessary problems which then need to be addressed.

A better approach would be to make LSM a statically linked interface.

This would also allow us to unexport the LSM symbols and reduce the API 
abuse by third-party modules.


- James
-- 
James Morris
<jmorris@namei.org>
