Return-Path: <linux-kernel-owner+w=401wt.eu-S1758481AbXEUQ1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758481AbXEUQ1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755773AbXEUQ1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:27:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:49193 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627AbXEUQ1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:27:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WDMyo5Ud+v+i9hb+I6XseVVW6qNf7ICOYYkI1qHJqO6oIb8yyE90BhGkLsDNGzg3wvFcnrM4z8V52lzHrpj/SatuOB8WmiaEyCeGwDEOWotfDXS+IidtRbrNpnqisVj7nIpKLJ92pfgjrwMEMHpc6vZLP5DYvD6xVAqAznqKcd4=
Message-ID: <21d7e9970705210927s1454dc5ete89005715253f4b7@mail.gmail.com>
Date: Mon, 21 May 2007 17:27:15 +0100
From: "Dave Airlie" <airlied@gmail.com>
To: "Jon Smirl" <jonsmirl@gmail.com>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Helge Hafting" <helge.hafting@aitel.hist.no>,
       "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <9e4733910705210907g70142adfhcaf01bd6791f113d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705171423.46748.jesse.barnes@intel.com>
	 <21d7e9970705210227x27234e2dme4e731a53f977082@mail.gmail.com>
	 <46516A14.2000102@aitel.hist.no>
	 <200705210857.44911.jbarnes@virtuousgeek.org>
	 <9e4733910705210907g70142adfhcaf01bd6791f113d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> What about modifying the existing fbdev API? You could start with one
> fbdev device per CRTC and then add a new IOCTL to control the output
> device. I haven't seen anything yet that justifies abandoning the
> existing fbdev API.

Then you can't aribtrate properly output hooking is a root level
thing, you cannot allow the user in multiseat to just pick his own
outputs, if you claim to want a truly flexible interfaces, also the
crtc->output mappings aren't always simple, there are limitations on
most hw about which crtc can map to which output and when you can
clone etc.. putting policy for this stuff in-kernel would heavily
restrict what the user can do...

At the moment, you can with a small userspace app add two
framebuffers, link them to crtcs and link those to outputs, then users
can use /dev/fb/* to do what they need, we haven't linked up mode
setting so that fbset works yet I don't think, but if people really
wanted that we could probably do so... so far we just have enough
fbdev to support fbcon...

Dave.
