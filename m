Return-Path: <linux-kernel-owner+w=401wt.eu-S933176AbXAaMka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176AbXAaMka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 07:40:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933146AbXAaMk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 07:40:29 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:46226 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933176AbXAaMk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 07:40:27 -0500
Message-ID: <45C08E33.9030300@hitachi.com>
Date: Wed, 31 Jan 2007 21:40:19 +0900
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
Cc: akpm@osdl.org, pavel@ucw.cz, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, alan@lxorguk.ukuu.org.uk,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>,
       "Hideo AOKI@redhat" <haoki@redhat.com>
Subject: Re: [PATCH 0/4] coredump: core dump masking support v2
References: <45BA0A93.30004@hitachi.com> 
    <20070126152907.GB30950@lnx-holt.americas.sgi.com> 
    <45BEF582.7080004@hitachi.com> 
    <20070130124417.GA7320@lnx-holt.americas.sgi.com>
In-Reply-To: <20070130124417.GA7320@lnx-holt.americas.sgi.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Robin Holt wrote:
>>>Can you make this a little more transparent?  Having a magic bitmask does
>>>not seem like the best way to do stuff.  Could you maybe make a core_flags
>>>directory with a seperate file for each flag.  It could still map to a
>>>single field in the mm, but be broken out for the proc filesystem.
>>
>>It seems to be one of the good enhancement idea, thanks.:-)
>>But currently, there is only one flag. So we had better keep this simple
>>implementation until someone requests to add a new flag.
> 
> If that is the case, can we rename the file from core_flags to something
> more descriptive like dump_core_skip_anonymous_mappings.  The name
> is a wild suggestion, the renaming does seem fairly important to me.
> Remember once you get this in, changing the name will be fairly difficult
> as admin tools and documentation will adopt the name.  These are usually
> cases where it is better to do it right the first time.

Okay, I'll adopt your idea in the next version.
I'm going to provide the proc entry as follows:

  (1) /proc/<pid>/core_flags/flags
  (2) /proc/<pid>/core_flags/omit_anon_shared

(1) is the same as current core_flags. It is for expert users.
(2) corresponds to one bit in (1).
If (2) is set to 1, anonymous shared memory of the process is never
dumped.

Thanks,
-- 
Hidehiro Kawai
Hitachi, Ltd., Systems Development Laboratory


