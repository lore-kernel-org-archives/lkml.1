Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbXKBMfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbXKBMfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 08:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbXKBMfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 08:35:08 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:48315 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbXKBMfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 08:35:07 -0400
Date: Fri, 2 Nov 2007 12:34:30 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-mips@linux-mips.org,
       Martijn Uffing <mp3project@sarijopen.student.utwente.nl>
Subject: Re: [IDE] Fix build bug
Message-ID: <20071102123428.GA14106@linux-mips.org>
References: <20071025135334.GA23272@linux-mips.org> <200710301134.30087.vda.linux@googlemail.com> <20071030124155.GA7582@linux-mips.org> <200711011843.16894.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711011843.16894.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2007 at 06:43:16PM +0000, Denys Vlasenko wrote:

> We can intrduce new, ro sections or teach gcc that combining const objects into
> non-ro sections is not a crime. I wonder why it currently disallows that.
> (And it does it only _somethimes_, const pointers happily go into rw sections!)

The pattern seems to be that const-ness of the first object placed into
a particular section determines the writability of that section.  If that
conflicts with the requirements for a later object such as a non-const
object into a section r/o gcc doesn't consider making the section r/w
but throws an error instead.

  Ralf
