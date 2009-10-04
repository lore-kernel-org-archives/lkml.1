Return-Path: <linux-kernel-owner+w=401wt.eu-S1756534AbZJDA6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbZJDA6e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 20:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755380AbZJDA6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 20:58:34 -0400
Received: from mail-qy0-f173.google.com ([209.85.221.173]:56833 "EHLO
	mail-qy0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106AbZJDA6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 20:58:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=SvgENYAa7YLfXPXcFAEOzhZCYGUxDP3my4grvshu2tyMJkL323TcHXMuuKym65sL6Y
         2EOjYNehkMUG62rWu311AWeO6EUV8AGXcmM3bv6r9O1xnNdCIeSC8n/hJ6ldD81mkPdP
         zotNqLl0q6Q7irMDwen5uiJhsUBbfANT7Zj9w=
Message-ID: <4AC7F306.2040409@gmail.com>
Date: Sat, 03 Oct 2009 18:57:42 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: David Fries <david@fries.net>
CC: linux-kernel@vger.kernel.org, d.stussy@yahoo.com,
       Joao Ramos <joao.ramos@inov.pt>, Linus Torvalds <torvalds@osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [bisected] 2.6.31 regression sis5513 PIO Mode 0 hang
References: <20091003025415.GA28295@spacedout.fries.net>
In-Reply-To: <20091003025415.GA28295@spacedout.fries.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2009 08:54 PM, David Fries wrote:
> I just did a git bisection from 2.6.30 to 2.6.31 because 2.6.31 will
> not boot on this system.  d.stussy@yahoo.com's post September 12th
> looks the same, different CPU but both have sis5513 IDE chips.  His
> would normally init the ethernet chip next, mine would do PS/2 next,
> both hang right after the Uniform CD-ROM message.
>
> This was bisected down to chaging PIO mode 0 for probing.  What
> problem was that patch trying to solve?  Reverting just that patch at
> the top of 2.6.31 tree works.  I can test patches.
>
> Assigned bugzilla.kernel.org bug 14310

Well, it's the right thing to do (libata does it) but presumably doing 
that in old IDE is triggering some kind of bug. Unless there's a 
specific problem it was solving, or someone is interested in debugging 
in detail (I'm certainly not interested in drivers/ide) it should likely 
be reverted as we've done without it for so long..
