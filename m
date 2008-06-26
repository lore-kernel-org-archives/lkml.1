Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbYFZJGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbYFZJGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 05:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYFZJGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 05:06:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41147
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751513AbYFZJGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 05:06:22 -0400
Date: Thu, 26 Jun 2008 02:06:21 -0700 (PDT)
Message-Id: <20080626.020621.45250426.davem@davemloft.net>
To: bart.vanassche@gmail.com
Cc: mpatocka@redhat.com, helge.hafting@aitel.hist.no,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Subject: Re: [10 PATCHES] inline functions to avoid stack overflow
From: David Miller <davem@davemloft.net>
In-Reply-To: <e2e108260806252332k3ffe3c63o29556f5b9d89c4a3@mail.gmail.com>
References: <Pine.LNX.4.64.0806250843460.20379@engineering.redhat.com>
	<20080625.150931.182895076.davem@davemloft.net>
	<e2e108260806252332k3ffe3c63o29556f5b9d89c4a3@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Bart Van Assche" <bart.vanassche@gmail.com>
Date: Thu, 26 Jun 2008 08:32:35 +0200

> On Thu, Jun 26, 2008 at 12:09 AM, David Miller <davem@davemloft.net> wrote:
> > The extra 16 bytes of space allocated is so that GCC can perform a
> > secondary reload of a quad floating point value.  It always has to be
> > present, because we can't satisfy a secondary reload by emitting yet
> > another reload, it's the end of the possible level of recursions
> > allowed by the reload pass.
> 
> Is there any floating-point code present in the Linux kernel ?

Yes, but not coming from C compiled code.  Floating point is
used in most of the memcpy/memset implementations of the
sparc64 kernel.

> Would it be a good idea to add an option to gcc that tells gcc that
> the compiled code does not contain floating-point instructions, such
> that gcc knows that no space has to be provided for a quad floating
> point value ?

I think it exists already, it's called -mno-fpu :-)
