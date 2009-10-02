Return-Path: <linux-kernel-owner+w=401wt.eu-S1758047AbZJBU2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbZJBU2B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 16:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757727AbZJBU2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 16:28:00 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:33515 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756969AbZJBU17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 16:27:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DJ84Xv/6PI/E7i0A6X77NIk3LQeBbtD0apYho/+xVXOX8/TPKwOChRWc7Ufogtyksi
         7sfvouA2/OTuwO+6TZoA7QiPtiR7LYRe/oR6HlB4jY0m7Vg0N9IleYzv8y1yKzlp1fpu
         5/4TMz0EQ4DlIm2LdMw/lTCsrJHLJNV2IZexU=
Date: Sat, 3 Oct 2009 00:27:59 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Oren Laadan <orenl@librato.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, arnd@arndb.de,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       mingo@elte.hu, Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       torvalds@linux-foundation.org, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v7][PATCH 0/9] Implement clone2() system call
Message-ID: <20091002202759.GA4826@x200>
References: <20090924165548.GA16586@us.ibm.com>
 <20090924175542.GA27678@x200>
 <20090924183556.GA31356@us.ibm.com>
 <20090930053443.GA1010@x200>
 <4AC39859.3090703@librato.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC39859.3090703@librato.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 01:41:45PM -0400, Oren Laadan wrote:
> Alexey Dobriyan wrote:
> > On Thu, Sep 24, 2009 at 01:35:56PM -0500, Serge E. Hallyn wrote:
> >> Quoting Alexey Dobriyan (adobriyan@gmail.com):
> >>> I don't like this even more.
> >>>
> >>> Pid namespaces are hierarchical _and_ anonymous, so simply
> >>> set of numbers doesn't describe the final object.
> >>>
> >>> struct pid isn't special, it's just another invariant if you like
> >>> as far as C/R is concerned, but system call is made special wrt pids.
> >>>
> >>> What will be in an image? I hope "struct kstate_image_pid" with several
> >> Sure pid namespaces are anonymous, but we will give each an 'objref'
> >> valid only for a checkpoint image, and store the relationship between
> >> pid namespaces based on those objrefs.  Basically the same way that user
> >> structs and hierarchical user namespaces are handled right now.
> > 
> > OK, that's certainly doable.
> > 
> > You're commiting yourself to creation of tasks in userspace if this goes in. :-\
> > Which can let you into putting wrong kind of relations into image.
> 
> A malicious user can put "wrong" king of relations into the image,
> regardless of whether the tasks are created in the kernel or in
> userspace. As long as the creation follows the "instructions" in
> the image, the result would be the same.

Wrong as in "fundamentally wrong", not malicious.
In case of uts_ns, the correct data to put into image is "task uses this uts_ns",
not "at this point do clone(CLONE_NEWUTS)".

BTW, now I'm convinced that nsproxy should not even be mentioned be in an image,
it's irrelevant technical detail, not future-proof at all.
