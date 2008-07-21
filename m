Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbYGUXZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbYGUXZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 19:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754063AbYGUXY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 19:24:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57878 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696AbYGUXY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 19:24:57 -0400
Message-ID: <48851AC2.8030007@zytor.com>
Date: Mon, 21 Jul 2008 19:24:50 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Ivan Seskar <Seskar@winlab.rutgers.edu>, jfm3 <jfm3@winlab.rutgers.edu>,
       Sujith <m.sujith@gmail.com>
Subject: Re: Bug on 2.6.26 - x86 VIA Nehemiah CentaurHauls processor cannot
 boot
References: <43e72e890807210614y58065d75j5b2fb3c5ebe6180a@mail.gmail.com>	 <48848DDF.6010903@zytor.com> <43e72e890807210701w6d7f5638w5fdbea76a1cf1c0b@mail.gmail.com>
In-Reply-To: <43e72e890807210701w6d7f5638w5fdbea76a1cf1c0b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis R. Rodriguez wrote:
> On Mon, Jul 21, 2008 at 6:23 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Luis R. Rodriguez wrote:
>>> This bug seems to be present since 2.6.22 [1], so hope we can get this
>>> fixed ASAP. Let me know if you have patch suggestions I can test.
>>>
>>> This crashes very early, I had to use earlyprintk to get it.
>>>
> 
> I've put extra spaces between the culprit.
> 
> c0387ac2:       0f 1f 40 00             nopl   0x0(%eax)
> 

Sure enough, our old friend.

You have in your configuration:

CONFIG_M686=y
# CONFIG_X86_GENERIC is not set

... so this is fully expected; CONFIG_M686 without CONFIG_X86_GENERIC is 
not compatible with such processors.

Not a bug.

	-hpa

