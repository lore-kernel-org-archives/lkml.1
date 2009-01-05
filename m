Return-Path: <linux-kernel-owner+w=401wt.eu-S1753238AbZAEQWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbZAEQWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 11:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750971AbZAEQWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 11:22:39 -0500
Received: from qmta02.westchester.pa.mail.comcast.net ([76.96.62.24]:49877
	"EHLO QMTA02.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751328AbZAEQWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 11:22:38 -0500
Subject: Re: [PATCH 2/2] input: Add a detailed multi-touch finger data
	report  protocol (rev2)
From: Jim Gettys <jg@laptop.org>
Reply-To: jg@laptop.org
To: Peter Hutterer <peter.hutterer@who-t.net>
Cc: Henrik Rydberg <rydberg@euromail.se>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090105035758.GA28664@dingo.redhat.com>
References: <495804B1.10300@euromail.se>
	 <20090105035758.GA28664@dingo.redhat.com>
Content-Type: text/plain
Organization: One Laptop Per Child
Date: Mon, 05 Jan 2009 11:22:33 -0500
Message-Id: <1231172553.8379.12.camel@jg-vaio>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-05 at 13:57 +1000, Peter Hutterer wrote:
> On Sun, Dec 28, 2008 at 11:58:57PM +0100, Henrik Rydberg wrote:
> > In order to utilize the full power of the new multi-touch devices, a
> > way to report detailed finger data to user space is needed. This patch
> > adds a multi-touch (MT) protocol which allows drivers to report details
> > for an arbitrary number of fingers.
> > 
> > The driver sends a SYN_MT_REPORT event via the input_mt_sync() function
> > when a complete finger has been reported.
> > 
> > In order to stay compatible with existing applications, the data
> > reported in a finger packet must not be recognized as single-touch
> > events. In addition, all finger data must bypass input filtering,
> > since subsequent events of the same type refer to different fingers.
> > 
> > A set of ABS_MT events with the desired properties are defined. The
> > events are divided into categories, to allow for partial implementation.
> > The minimum set consists of ABS_MT_TOUCH_MAJOR, ABS_MT_POSITION_X and
> > ABS_MT_POSITION_Y, which allows for multiple fingers to be tracked.
> > If the device supports it, the ABS_MT_WIDTH_MAJOR may be used to provide
> > the size of the approaching finger. Anisotropy and direction may be
> > specified with ABS_MT_TOUCH_MINOR, ABS_MT_WIDTH_MINOR and
> > ABS_MT_ORIENTATION. Devices with more granular information may specify
> > general shapes as blobs, i.e., as a sequence of rectangular shapes
> > grouped together by a ABS_MT_BLOB_ID. 
> 
> To clarify: the MT_TOUCH_MAJOR is to track a touchpoint over time, and the
> BLOB_ID to compile a arbitrarily shaped touchpoint within the same event?
> 
> Would it make sense to allow specification of a blob as bit/bytemask? There
> are a few devices that can do detection of multi-color non-rectangular
> touchpoints, especially camera-based systems. Limiting these to a sequence of
> rectangles means dropping information that may be useful for certain tasks
> (e.g. fingerprint detection).
> OTOH, a rectangle as bounding box with an accompanying (optional) bytemask can
> pass this data on to prospective clients.

Urk.  I'd forgotten entirely about color.  Some people are certainly
using tokens on surfaces, distinguishable either by shape or color. But
maybe that is better left outside of this until we have a more concrete
non-research system to grok before defining a kernel interface; many of
these systems may be doing advanced image processing in user space
processes and talking directly to X with the result rather than
via /dev/input....  Or do you feel you have good enough experience with
the MERL table and other systems to take a stab at it now?
                               - Jim

-- 
Jim Gettys <jg@laptop.org>
One Laptop Per Child

