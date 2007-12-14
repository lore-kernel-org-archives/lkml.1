Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbXLNSZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbXLNSZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 13:25:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbXLNSZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 13:25:25 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:23762 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbXLNSZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 13:25:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=a32SjXFSZCqCxeN8yjb2YDSPZeYEZ+nu9JE1hKQqtZx2lcJcwW+RQHyFuo+7aKq7fe7h/aTJGwML+1UIDCzpjgQcN8vBB9nYWQYdS6GDxQ9WJcgZfsmbC7+P56XHU3pSmM+uN5rP/HYKvOJWIgO0kKFdoTo8afiGMFGnMMFxzqk=
Message-ID: <4762CA33.4080202@keyaccess.nl>
Date: Fri, 14 Dec 2007 19:23:47 +0100
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, "David P. Reed" <dpreed@reed.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
 on some AMD64x2 laptops, etc.
References: <466F0941.9060201@reed.com> <1181682498.8176.224.camel@chaos> <469578CD.3080609@reed.com> <1184216528.12353.203.camel@chaos> <1184218962.12353.209.camel@chaos> <46964352.7040301@reed.com> <1184253339.12353.223.camel@chaos> <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <20071214131502.GA14359@elte.hu> <4762C551.5070003@zytor.com>
In-Reply-To: <4762C551.5070003@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
From: Rene Herman <rene.herman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-12-07 19:02, H. Peter Anvin wrote:

> I believe this will suffer from the issue that was raised: this will use
> udelay() long before loop calibration (and no, we can't just "be 
> conservative" since there is no "conservative" value we can use.)
> 
> Worse, I suspect that at least the PIT, which may need to be used for 
> udelay calibration, is one of the devices that may be affected.  I have 
> seen the Verilog for a contemporary chipset, and it can only access the 
> PIT once per microsecond -- this actually has to do with the definition 
> of the PIT; some of the PIT operations are ill-defined if allowed at a 
> higher frequency than the PIT clock.

Was reported before indeed:

http://linux.derkeiler.com/Mailing-Lists/Kernel/2003-09/5764.html

Rene.

