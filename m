Return-Path: <linux-kernel-owner+w=401wt.eu-S1753229AbZBAOda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbZBAOda (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 09:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbZBAOdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 09:33:21 -0500
Received: from fifo99.com ([67.223.236.141]:49504 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290AbZBAOdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 09:33:20 -0500
Subject: Re: checkpatch.pl is getting too slow
From: Daniel Walker <dwalker@fifo99.com>
To: Greg KH <greg@kroah.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20090201044614.GA8589@kroah.com>
References: <20090131185507.GA3280@kroah.com>
	 <20090131210220.GA25811@shadowen.org> <1233449877.5903.48.camel@desktop>
	 <20090201044614.GA8589@kroah.com>
Content-Type: text/plain
Date: Sun, 01 Feb 2009 06:33:14 -0800
Message-Id: <1233498794.5903.68.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-31 at 20:46 -0800, Greg KH wrote:

> But defines do cross a line, and we should be able to check them
> properly, isn't that what the original version of this was doing?

The current version isn't able to detect the end of a define, single
line or multi-line .. I think it only see's a semi-colon as a block
ending, or "}".

so if you had,

#define block_one (1)
#define block_two (2)
... [100 more single line defines] ...
int i = block_one + block_two;

The processing starts at "block_one" and that block ends at "int i =
block_one + block_two;" , since that's the only line with a semi-colon.
Then the processing moves to the next line "block_two" and that block
also ends at "int i = block_one + block_two;" , and that happens 100
times for each define moving down.

However, each define should really be seen as a block of only one line,
or when there's a multi-line define that should all be one block.

Daniel



