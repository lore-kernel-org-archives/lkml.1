Return-Path: <linux-kernel-owner+w=401wt.eu-S1753669AbYJAIUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbYJAIUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 04:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751037AbYJAIUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 04:20:04 -0400
Received: from ms0.nttdata.co.jp ([163.135.193.231]:35978 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbYJAIUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 04:20:03 -0400
Message-ID: <48E332AE.7050001@nttdata.co.jp>
Date: Wed, 01 Oct 2008 17:19:58 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.8.1.17) Gecko/20080914 Thunderbird/2.0.0.17 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Stephen Smalley <sds@tycho.nsa.gov>, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, haradats@nttdata.co.jp,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [TOMOYO #9 (2.6.27-rc7-mm1) 1/6] LSM adapter functions.
References: <20080924090317.359685535@nttdata.co.jp> <20080924090338.407746083@nttdata.co.jp> <20080925165954.GA25587@us.ibm.com> <48DC7553.8040708@nttdata.co.jp> <20080926130409.GA14055@us.ibm.com> <48E053DB.3010201@nttdata.co.jp> <20080930154553.GA29249@us.ibm.com> <1222791288.19676.114.camel@moss-spartans.epoch.ncsc.mil> <20080930162321.GA31779@us.ibm.com>
In-Reply-To: <20080930162321.GA31779@us.ibm.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Oct 2008 08:19:59.0411 (UTC) FILETIME=[7EB11830:01C9239E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
>> harmless application/library probing that would be denied by DAC anyway.
>> Same issue would seemingly apply for learning modes of TOMOYO or
>> AppArmor.
> Good point.  Kentaro, is that an issue for you?
Indeed, since learning mode of TOMOYO is inherently the same feature 
as auditing, it is affected by noise. But it doesn't matter so much. 
The main problem is the difference of error code between DAC and MAC. 
DAC errors such as ENOENT or EROFS should be returned to callers 
first so that callers will not be surprised by MAC errors such as 
EPERM.

Regards,

