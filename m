Return-Path: <linux-kernel-owner+w=401wt.eu-S1754384AbXLDPZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbXLDPZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 10:25:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbXLDPZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 10:25:37 -0500
Received: from nz-out-0506.google.com ([64.233.162.229]:57556 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbXLDPZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 10:25:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MezjbDXiSJZ1ms89KI9iAH6iwEWrWxN0ht2bXdKfym6Cqol2iPRM/QXw+boQlR3WlqMJ/E6FUgtUFhpJGYFBq0U93RuBJ+qAQbyVZsS6s1dyUzGv8Vrp9gBOKwGwc857E4rqvpgbDs9KXMdV2veCQQJm4AJaoYTpKWSk3n/HKQk=
Message-ID: <170fa0d20712040725o506a47cayb137993041ec3a63@mail.gmail.com>
Date: Tue, 4 Dec 2007 10:25:29 -0500
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Subject: Re: [0/4] DST: Distributed storage.
Cc: lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <11967790263179@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <aqqqqasdzxczc036@2ka.mipt.ru> <11967790263179@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 4, 2007 9:37 AM, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
>
> Distributed storage.
>
> I'm pleased to announce the 10'th release of the distributed
> storage subsystem (DST). This is a maintenance release and includes
> bug fixes and simple feature extensions only.
>
> DST allows to form a storage on top of local and remote nodes
> and combine them into linear or mirroring setup, which in
> turn can be exported to remote nodes.
>
> Short changelog:
>  * fixed bug with XFS metadata update (it can provide slab pages to the
>         DST, so it is not allowed to transfer them using ->sendpage())
>  * fixed async error completion path
>  * extended netlink communication channel to report errors back to userspace
>  * DST name is now "The 10'th dynasty of smuggled slothes"
>  * number of fixes for userspace DST target
>
> Great thanks to Matthew Hodgson <matthew@mxtelecom.com> for debugging and
> fixes for userspace DST target and preliminary netlink extension patches.
>
> Overall list of features of the DST can be found on project's homepage:
>
> http://tservice.net.ru/~s0mbre/old/?section=projects&item=dst
>
> Thank you.
>
> Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

Evgeniy,

Thanks for your continued work on DST.  I'd like to know if you've
thought further about how synchronous mirroring would be best
implemented with DST.

You shared you views some time ago via comments on your blog:
http://tservice.net.ru/~s0mbre/blog/devel/dst/2007_11_05.html

At that time you were saying you'd add a sync bit to the request
structure that is sent to remote nodes.  I'd imagine this would also
require ordering of the block io, no?  Is order guaranteed when the
requests are submitted over the DST protocol?  Otherwise how can you
ensure a valid remote mirror (in the case of network disconnects,
etc)?

Guaranteeing consistent data on all members of a mirror is important.
The main question is: what mechanisms _should_ be used in DST to
provide this consistency?  And do you have a timeframe for when DST
might support such mechanisms for consistent data?

For the purpose of this discussion please assume that the disk cache
is either write-through or battery-backed.

regards,
Mike
