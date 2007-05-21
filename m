Return-Path: <linux-kernel-owner+w=401wt.eu-S1760798AbXEURmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760798AbXEURmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 13:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756187AbXEURmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 13:42:39 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:8438 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090AbXEURmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 13:42:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oPNbYU4rHOZ4dW3OhP12w3FMHR5HiTeS0/2CU8OsgvbgizoVULJYQLo7alr6pD05+VhZRU0si8FPelydg/lAS4S4QuKiBdi1QCAfPKLOLJW1GU4ez+ejf7nZSeXTlgmDtXdk6JO3WAmRtM0lObeyMvzvzjH7f03anhfY6IZ0tMU=
Message-ID: <9e4733910705211042o8926e4cy2225c2dbcbf3ff2@mail.gmail.com>
Date: Mon, 21 May 2007 13:42:36 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Dave Airlie" <airlied@gmail.com>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <21d7e9970705211014j6eb59326u85f7347a3000f3d3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705171423.46748.jesse.barnes@intel.com>
	 <9e4733910705210901v5996cacas640f211404c519c6@mail.gmail.com>
	 <200705210914.22663.jbarnes@virtuousgeek.org>
	 <200705210934.58559.jbarnes@virtuousgeek.org>
	 <9e4733910705211005k761c976o1a6b270d87b49589@mail.gmail.com>
	 <21d7e9970705211014j6eb59326u85f7347a3000f3d3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Dave Airlie <airlied@gmail.com> wrote:
> This just needs a userspace console again a parallel problem that
> really isn't much to do with the problem set this work is trying to
> solve... it should enable it...

When I went through the design process for all this I came to the same
conclusion about needing a user space console process.

User space console does impact on all of this because it implies that
the current console should be be defeatured down until it becomes only
a system recovery console and not a console for everyday use.

For example, one part of the defeaturing would be to remove the
drawing acceleration code in the existing fbdev console drivers and to
rework it to support accelerated drawing from the user space console
implementation. You want the system recovery console mode to be as
simple as possible so that it is always guaranteed to work. User space
console is also what leads to the idea of compiling VT out of the
kernel.

Once you decide that a user space console is needed then the per CRTC
device node becomes more obvious since different people can be logged
onto the different consoles.

All of the points in the list are interrelated and the architecture
needs to address everything as a unified whole.

-- 
Jon Smirl
jonsmirl@gmail.com
