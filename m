Return-Path: <linux-kernel-owner+w=401wt.eu-S933148AbXFSDRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148AbXFSDRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 23:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763135AbXFSDRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 23:17:04 -0400
Received: from smtpout.mac.com ([17.250.248.174]:57439 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762088AbXFSDRB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 23:17:01 -0400
In-Reply-To: <20070618212423.GB19713@cynthia.pants.nu>
References: <8wsW4-3UY-3@gated-at.bofh.it> <8wJal-3KA-1@gated-at.bofh.it> <8xm22-4Ql-1@gated-at.bofh.it> <8xq5G-32l-7@gated-at.bofh.it> <8xs7w-69W-21@gated-at.bofh.it> <E1I0OFQ-0001B9-7Z@be1.lrz> <Pine.LNX.4.64.0706181406250.25913@blackbox.fnordora.org> <4676F9A2.6010007@zytor.com> <20070618221021.GB2062@thunk.org> <20070618222656.GB25089@lazybastard.org> <20070618212423.GB19713@cynthia.pants.nu>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=ISO-8859-1; delsp=yes; format=flowed
Message-Id: <B6DEBB6D-9929-46BF-A43C-AB5B20070AAA@mac.com>
Cc: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
       Theodore Tso <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
       alan <alan@clueserver.org>, Bodo Eggert <7eggert@gmx.de>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Content-Transfer-Encoding: 8BIT
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Versioning file system
Date: Mon, 18 Jun 2007 23:15:51 -0400
To: Brad Boyer <flar@allandria.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 18, 2007, at 17:24:23, Brad Boyer wrote:
> On Tue, Jun 19, 2007 at 12:26:57AM +0200, Jörn Engel wrote:
>> Pointless here means that _I_ don't see the point.  Maybe there  
>> are valid uses for extended attributes.  If there are, noone has  
>> explained them to me yet.
>
> The users of extended attributes that I've dealt with are ACL  
> support and SELinux. These both use extended attributes under the  
> covers. It's just not immediately obvious if you aren't looking.

Yeah, extended attributes are typically used for exactly that:  
"attributes" like labels, permissions, encoding, cached file-type,  
DOS/Windows/Mac metadata, etc.  Sometimes people suggest sticking  
icons in there, but that's probably a bad idea.  At most stick an  
"icon label" attribute which refers to a file "/usr/share/icons/ 
by_attr/$ICON_LABEL.png".  If you're trying to put more than 256  
bytes of data in an extended attribute then you're probably doing  
something wrong.  They're very good for cached attributes (like file- 
type) where you don't care if the data is lost by "tar", and they're  
reasonable for security-related attributes where you don't want  
attribute-unaware programs trying to save and restore them (like  
SELinux labels).

Cheers,
Kyle Moffett

