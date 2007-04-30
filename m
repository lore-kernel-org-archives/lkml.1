Return-Path: <linux-kernel-owner+w=401wt.eu-S1946351AbXD3Qac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946351AbXD3Qac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946354AbXD3Qac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:30:32 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:14276 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946351AbXD3Qaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:30:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fLZHt4Vsx7mF8qZyJ7db+FF47bjlCOfrU+j2ALMkawbbfvXkWTZp4yF5b/OyqF1rFGrrAOc/YtNK9L2eEdbjaCkiiUK7fcdwc9oic41O7w97H1nAdRe8IJYQFeuOqbzw7PnkK1XMCvTzLDFrgnTVDJK/l+A7h6DInvqJSXEw68A=
Message-ID: <a4e6962a0704300930r7e048a48u7c312b14beefcffd@mail.gmail.com>
Date: Mon, 30 Apr 2007 11:30:29 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>,
       "Latchesar Ionkov" <lionkov@gmail.com>, "Andrew Morton" <akpm@osdl.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "V9FS Developers" <v9fs-developer@lists.sourceforge.net>
Subject: Re: [V9fs-developer] [PATCH] 9p: create separate 9p client interface
In-Reply-To: <20070430161318.GA29321@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f158dc670704300832l36889bf2kfa4480addbe8cfb2@mail.gmail.com>
	 <20070430161318.GA29321@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/30/07, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Apr 30, 2007 at 09:32:41AM -0600, Latchesar Ionkov wrote:
> > Create a separate 9P client interface that can be used outside the VFS
> > layer. In addition to VFS, the new interface can be used to export the
> > authentication channel or from other interfaces.
>
> And what exact users would that be?  We have a huge dislike for putting
> abstractions in just for the abstractions sake, so if you want this
> merged you'd better present a highly useful client to that interface.
>

I'll let Lucho give more details on his possible uses for such an
interface -- for my part we have been looking at doing in-kernel
servers for more efficient export of devices and system services (such
as the network stack).  We've been using user space applications for
doing such sharing, but there are undesirable inefficiencies in such
an approach.

>>19 files changed, 1656 insertions(+), 1585 deletions(-)

I believe the log message was poorly worded, it was more of a
reorganization of the existing interface versus the creation of an
additional interface.

>
> Also the non-filesystem interface code shouldn't live in fs/ but
> rather in net/9p/
>

Which bits do you think are candidates for such a move?  The transport
interfaces? (there are a few more in the wings to cover shared memory
transports for VMMs among other things)  Should the protocol elements
move as well? -- that seems a bit fuzzier to me.

            -eric
