Return-Path: <linux-kernel-owner+w=401wt.eu-S2992879AbXEBHR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992879AbXEBHR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 03:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992880AbXEBHR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 03:17:26 -0400
Received: from smtp-out.google.com ([216.239.45.13]:12199 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992879AbXEBHRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 03:17:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=O0ITWA5i+KwiHMrkaVncKoxio2PICv922Yd+ruvBGzomaq5EqR85035h5/m2WtHFF
	qkwobXDt073x0QK5oJbvA==
Date: Wed, 2 May 2007 00:17:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Robert P. J. Day" <rpjday@mindspring.com>
cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] compiler: define __attribute_unused__
In-Reply-To: <Pine.LNX.4.64.0705020257520.5859@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0705020015470.22717@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com>
 <20070502051723.GB5843@martell.zuzino.mipt.ru>
 <Pine.LNX.4.64.0705020257520.5859@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Robert P. J. Day wrote:

>   not only that, but there are numerous files that *already* use
> "__unused":
> 
> $ grep -rw __unused *
> ... snip lots of output here ...
> 
> as well as a few files that can now have their definition of that
> removed:
> 
> $ grep -r "define __unused" *
> drivers/net/defxx.c:#define __unused __attribute__ ((unused))
> drivers/net/declance.c:#define __unused __attribute__ ((unused))
> drivers/misc/thinkpad_acpi.c:#define __unused __attribute__ ((unused))
> 
>   i think "__unused" is the clear choice here.
> 

No, it's not the clear choice.  This would apply to both functions and 
variables so the suppress a compiler warning for a variable whose use 
depends on preprocessor macros, I would have to use __unused even though 
it may be used.

Hence, I recommend __maybe_unused.
