Return-Path: <linux-kernel-owner+w=401wt.eu-S1760295AbXGIT6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760295AbXGIT6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 15:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755921AbXGIT6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 15:58:44 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:42273 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198AbXGIT6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 15:58:43 -0400
Subject: Re: [PATCH 0/16] Pid namespaces
From: Dave Hansen <haveblue@us.ibm.com>
To: Pavel Emelianov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>, Kirill Korotaev <dev@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>
In-Reply-To: <4691CE99.7030902@openvz.org>
References: <468DF6F7.1010906@openvz.org>
	 <1183739214.10287.127.camel@localhost>  <4691CE99.7030902@openvz.org>
Content-Type: text/plain
Date: Mon, 09 Jul 2007 12:58:37 -0700
Message-Id: <1184011118.10287.267.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-09 at 09:58 +0400, Pavel Emelianov wrote:
> Dave Hansen wrote:
> > On Fri, 2007-07-06 at 12:01 +0400, Pavel Emelianov wrote:
> >> This is "submition for inclusion" of hierarchical, not kconfig
> >> configurable, zero overheaded ;) pid namespaces.
> > 
> > Pavel, I'm a bit disappointed that you went ahead and sent this.  I
> > thought that, perhaps, you might have brought up how displeased you were
> > with Suka's patches when we discussed them at OLS.  
> > 
> > Hold your horses there a bit.  This has "little" overhead for the common
> > case, which is a single level of pid namespaces.  That means that it is
> > quick to access the "global" pid which would be the one that the "host
> > container" sees.  It also provides quick access to the pid which a
> > containerized task gets when the task itself calls getpid().  This quick
> > access is provided by storing the values directly in the task struct.
> > 
> > However, when there is more than one level in the container hierarchy,
> > the optimization breaks down.  A process which exists in a three-level
> > hierarchy has slow access to the middle level pid.  Your approach stores
> > this information in a linked list, and surely *that* is going to have
> 
> No. This approach stores numerical values in array. I have
> removed the lists at all.

Ahh.  I was confused by the hlist in 'struct pid'.  You are very correct.

Suka actually coded up something very, very similar to what you have.  I
just made him remove some of it so that the patches could be more easily
reviewed.  I figured we could add the fully dynamic allocation later,
which you have already done.  That part of your patches is remarkably
similar.  

-- Dave

