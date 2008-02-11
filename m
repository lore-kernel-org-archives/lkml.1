Return-Path: <linux-kernel-owner+w=401wt.eu-S1759758AbYBKT1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759758AbYBKT1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:27:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756608AbYBKT11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:27:27 -0500
Received: from smtp-out.google.com ([216.239.33.17]:8147 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527AbYBKT10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:27:26 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=f1HNBQ9etzeItf325FDl1A0YAICG8CD0SvZt37vAPTkYln04B7J1p8AnFribipyGz
	MdMOApl+RcR3HGw2ucO5Q==
Date: Mon, 11 Feb 2008 11:25:42 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <ak@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] mempolicy: convert MPOL constants to enum
In-Reply-To: <200802111945.05917.ak@suse.de>
Message-ID: <alpine.DEB.1.00.0802111122270.1671@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com> <200802111945.05917.ak@suse.de>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008, Andi Kleen wrote:

> > The mempolicy mode constants, MPOL_DEFAULT, MPOL_PREFERRED, MPOL_BIND,
> > and MPOL_INTERLEAVE, are better declared as part of an enum for type
> > checking.
> 
> What type checking? There is none in standard C for enums.
> 

"Type checking" probably isn't the best description for it.  As I 
mentioned in the changelog for the second patch in this series, a function 
with a formal type of 'enum mempolicy_mode' indicates that the optional 
mode flags have already been stripped off and the only possible values are 
those of 'enum mempolicy_mode'.  The implementation will not need to use 
mpol_mode() in conditionals or switch statements.  I think it's a clean 
way of describing what is acting on modes and what is acting on flags.

Functions with a formal type of an 'int' contain both the mode and flags.

		David
