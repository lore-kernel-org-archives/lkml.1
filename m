Return-Path: <linux-kernel-owner+w=401wt.eu-S1757636AbZA2AmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636AbZA2AmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbZA2AmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 19:42:07 -0500
Received: from main.gmane.org ([80.91.229.2]:52836 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbZA2AmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 19:42:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: open(2) says O_DIRECT works on 512 byte boundries?
Date: Wed, 28 Jan 2009 18:41:49 -0600
Message-ID: <4980FB4D.9090009@shaw.ca>
References: <20090128213322.GA15789@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: linux-man@vger.kernel.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
In-Reply-To: <20090128213322.GA15789@kroah.com>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> In looking at open(2), it says that O_DIRECT works on 512 byte boundries
> with the 2.6 kernel release:
> 	Under Linux 2.4, transfer sizes, and the alignment of the user
> 	buffer and  the file offset must all be multiples of the logical
> 	block size of the file system.  Under Linux 2.6, alignment  to
> 	512-byte  boundaries suffices.
> 
> However if you try to access an O_DIRECT opened file with a buffer that
> is PAGE_SIZE aligned + 512 bytes, it fails in a bad way (wrong data is
> read.)
> 
> Is this just a mistake in the documentation?  Or am I reading it
> incorrectly?
> 
> I have a test program that shows this if anyone wants it.

Well, it sounds like a bug to me.. even if it's not supported, if you do 
such an access, surely the kernel should detect that and return EINVAL 
or something rather than reading corrupted data..

