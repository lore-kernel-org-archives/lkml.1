Return-Path: <linux-kernel-owner+w=401wt.eu-S1757854AbYD0Fis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854AbYD0Fis (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 01:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbYD0Fil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 01:38:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54640 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbYD0Fik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 01:38:40 -0400
Date: Sun, 27 Apr 2008 06:38:37 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: cooloney@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blackfin checksum annotations
Message-ID: <20080427053837.GR5882@ZenIV.linux.org.uk>
References: <20080427052226.GP5882@ZenIV.linux.org.uk> <20080426.222644.74393287.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426.222644.74393287.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 10:26:44PM -0700, David Miller wrote:
> From: Al Viro <viro@ZenIV.linux.org.uk>
> Date: Sun, 27 Apr 2008 06:22:26 +0100
> 
> > 
> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> Since these are networking knobs and Al tends to test his
> changes, I'll apply this to the net-2.6 tree.

FSVOtest in this case, since I don't have the hardware...  However,
all changes seen by gcc are actually
	* explicit cast to unsigned short in return expression of functions
returning unsigned short
	* csum_fold() return type changed from unsigned int to __sum16
(unsigned short), same as for all other architecture and as net/* expects;
expression actually returned is ((~(sum << 16)) >> 16) with sum being
unsigned 32bit, so it's (a) going to fit into the range of unsigned short
and (b) had been unsigned all along, so no sign expansion mess happened.

IOW, it should not break runtime, but... untested is untested.
