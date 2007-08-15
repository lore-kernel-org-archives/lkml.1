Return-Path: <linux-kernel-owner+w=401wt.eu-S933642AbXHORZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933642AbXHORZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 13:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbXHORZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 13:25:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34161 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbXHORZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 13:25:30 -0400
Message-ID: <46C33700.1060605@zytor.com>
Date: Wed, 15 Aug 2007 10:25:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Guy Streeter <guy.streeter@gmail.com>
CC: James Pearson <james-p@moving-picture.com>, linux-kernel@vger.kernel.org
Subject: Re: 4096 byte limit to /proc/PID/environ ?
References: <4474B7DB.8000304@moving-picture.com>	 <200605242029.k4OKTn9C031700@terminus.zytor.com>	 <447EF58C.6000605@moving-picture.com> <52dd17640708150954q798d137cn1b07739785917c5b@mail.gmail.com>
In-Reply-To: <52dd17640708150954q798d137cn1b07739785917c5b@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Guy Streeter wrote:
> On 6/1/06, James Pearson <james-p@moving-picture.com> wrote:
>> H. Peter Anvin wrote:
>>> I think this is the wrong approach.
>>>
>>> Many of these should probably be converted to seq_file, but in the
>>> particular case of environ, the right approach is to observe the fact
>>> that reading environ is just like reading /proc/PID/mem, except:
>>>
>>>  a. the access restrictions are less strict, and
>>>  b. there is a range restriction, which needs to be enforced, and
>>>  c. there is an offset.
>>>
>>> Pretty much, take the guts from /proc/PID/mem and generalize it
>>> slightly, and you have the code that can run either /proc/PID/mem or
>>> /proc/PID/environ.
>> The following patch is based on the /proc/PID/mem code appears to work fine.
>>
> 
> This thread has gone stale. The PAGE_SIZE limit still exists. Is this
> solution acceptable?
> 

Can we avoid the code duplication?

	-hpa
