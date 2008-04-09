Return-Path: <linux-kernel-owner+w=401wt.eu-S1759480AbYDIQ1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480AbYDIQ1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 12:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756796AbYDIQZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 12:25:18 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:33813 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758720AbYDIQZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 12:25:11 -0400
Date: Wed, 9 Apr 2008 09:23:53 -0700
From: sukadev@us.ibm.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Containers <containers@lists.osdl.org>,
       Pavel Emelyanov <xemul@openvz.org>, serue@us.ibm.com, clg@fr.ibm.com
Subject: Re: [RFC][PATCH 0/7] Clone PTS namespace
Message-ID: <20080409162353.GA14044@us.ibm.com>
References: <20080408215333.GA8799@us.ibm.com> <47FC138B.4070408@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FC138B.4070408@zytor.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin [hpa@zytor.com] wrote:
> sukadev@us.ibm.com wrote:
>> Devpts namespace patchset
>> In continuation of the implementation of containers in mainline, we need 
>> to
>> support multiple PTY namespaces so that the PTY index (ie the tty names) 
>> in
>> one container is independent of the PTY indices of other containers.  For
>> instance this would allow each container to have a '/dev/pts/0' PTY and
>> refer to different terminals.
>
> Why do we "need" this?  There isn't a fundamental need for this to be a 
> dense numberspace (in fact, there are substantial reasons why it's a bad 
> idea; the only reason the namespace is dense at the moment is because of 
> the hideously bad handing of utmp in glibc.)  Other than indicies, this 
> seems to be a more special case of device isolation across namespaces, 
> would that be a more useful problem to solve across the board?

We want to provide isolation between containers, meaning PTYs in container
C1 should not be accessible to processes in C2 (unless C2 is an ancestor).

The other reason for this in the longer term is for checkpoint/restart.
When restarting an application we want to make sure that the PTY indices
it was using is available and isolated.

We started out with isolating just the indices but added the special-case
handling for granting the host visibility into a child-container.

A complete device-namespace could solve this, but IIUC, is being planned
in the longer term. We are hoping this would provide the isolation in the
near-term without being too intrusive or impeding the implementation of
the device namespace.

Sukadev
