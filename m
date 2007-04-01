Return-Path: <linux-kernel-owner+w=401wt.eu-S1751948AbXDADVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbXDADVT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 23:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbXDADVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 23:21:19 -0400
Received: from vitelus.com ([63.99.9.247]:36158 "EHLO vitelus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbXDADVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 23:21:18 -0400
Date: Sat, 31 Mar 2007 20:20:42 -0700
From: Aaron Lehmann <aaronl@vitelus.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Silent corruption on AMD64
Message-ID: <20070401032042.GU15189@vitelus.com>
References: <20070401012736.GT15189@vitelus.com> <20070331195236.7c818ed5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070331195236.7c818ed5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2007 at 07:52:36PM -0700, Andrew Morton wrote:
> Are you able to provide us with some before-and-after data so we
> can see this corruption.
> 
> See, if it's dropped-bits or shifted-data or eight-byte-aligned
> kernel addresses or whatever, that helps us generate theories..

Sure.

I created a large file containing the repeating ASCII string "abcdefgh",
and subjected it to the corruption I described earlier. The correct
hex sequence is:

61 62 63 64 65 66 67 68

Here were some of the permutations that I found in corrupted copies:

61 62 63 64 92 57 5C 0A
61 62 63 64 A2 2D E1 C7
61 62 63 64 11 38 0E B6
61 62 63 64 57 B1 EE 1F
61 62 63 64 E0 3D 10 21
61 62 63 64 97 E1 C0 F5

I did not observe any errors other than replacements of four-byte
blocks. These errors always started at addresses in the file that had
a remainder of 12 modulo 16 (i.e. the hex addresses always ended in
'C'). There was an average about one error per 300MB.
