Return-Path: <linux-kernel-owner+w=401wt.eu-S1755670AbZCJSeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbZCJSeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 14:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbZCJSeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 14:34:10 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:43697 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbZCJSeJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 14:34:09 -0400
MIME-Version: 1.0
In-Reply-To: <1236705538.6339.2.camel@quest>
References: <cover.1236702228.git.scott@canonical.com>
	 <c9944f91c6740450d11cb26c4e8e19e2cb612abe.1236702228.git.scott@canonical.com>
	 <20090310170802.GA4923@kroah.com> <1236705538.6339.2.camel@quest>
Date: Tue, 10 Mar 2009 19:34:05 +0100
Message-ID: <ac3eb2510903101134x7ab7dd8q2b958419625cae9@mail.gmail.com>
Subject: Re: [PATCH 26/31] usb: Auto-load cdc_acm module when device opened.
From: Kay Sievers <kay.sievers@vrfy.org>
To: Scott James Remnant <scott@canonical.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 18:18, Scott James Remnant <scott@canonical.com> wrote:
> On Tue, 2009-03-10 at 10:08 -0700, Greg KH wrote:
>> On Mon, Mar 02, 2009 at 06:46:15PM +0000, Scott James Remnant wrote:
>> > The cdc_acm module is missing the char-major-166-* alias that would
>> > cause it to be auto-loaded when a device of that type is opened.  This
>> > patch adds the alias.
>>
>> You really have users that are using a static /dev that need this kind
>> of fix?  I thought we were phasing out the char-major- aliases as they
>> don't make any sense anymore.
>>
> I don't think so.
>
> But since we had aliases to support users, I wasn't going to drop them
> without at least sending a patch upstream to see if they cared about
> such things.
>
> (and there are many modules which do have the char-major aliases, so at
> least someone is trying to put them in).
>
> As noted in the cover, feel free to drop these - I can use your reply
> when a user complains <g>

Yeah, we should put them into the module, where they belong, or just
remove them all. :) They surely do not belong into disconnected
userspace config files.

We are going to delete all kernel module configurations from the
userspace packages, and the only alternative for the kernel to provide
the autoload-by-open facility to users who like to use that, would be
that the kernel installs a modprobe config file which is maintained by
the kernel maintainers. Not sure if someone wants to do that instead.
:)

The new modprobe does not really care how many aliases we have, the
time to lookup the aliases depends mainly on the length of the alias
lookup string, not the number of strings to match against, so this
should all be fine.

Thanks,
Kay
