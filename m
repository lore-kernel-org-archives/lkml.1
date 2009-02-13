Return-Path: <linux-kernel-owner+w=401wt.eu-S1759501AbZBMIXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501AbZBMIXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 03:23:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbZBMIXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 03:23:32 -0500
Received: from mu-out-0910.google.com ([209.85.134.188]:16071 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbZBMIXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 03:23:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=s0eSjftUKeDXI/l8W++rfpZ43cLvLz/vwMOWCdR+hWM7wPbW2/pCG6u/nxukL9DrK9
         kv52ENfZlvNy6UPMd4v37jMcZHD4J2J/l2RHEDBbb7j6FsTyl+pJLgP5tnksjHqY2aac
         Xr3XYAKkz/PL+WXFOIVhrUayrzQCNen8tn3VQ=
Message-ID: <49952DFD.4050903@gmail.com>
Date: Fri, 13 Feb 2009 09:23:25 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Zhu Yi <yi.zhu@intel.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       James Ketrenos <jketreno@linux.intel.com>,
       "Chatre, Reinette" <reinette.chatre@intel.com>
Subject: Re: [PATCH 1/1] ipw2200, fix ipw io functions
References: <1234474180-910-1-git-send-email-jirislaby@gmail.com> <1234486180.6354.203.camel@debian>
In-Reply-To: <1234486180.6354.203.camel@debian>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2009 01:49 AM, Zhu Yi wrote:
> On Fri, 2009-02-13 at 05:29 +0800, Jiri Slaby wrote:
>>  /* alias to 8-bit direct read (low 4K of SRAM/regs), with debug
>> wrapper */
>> -#define ipw_read8(ipw, ofs) __ipw_read8(__FILE__, __LINE__, ipw, ofs)
>> +#define ipw_read8(ipw, ofs) ({ \
>> +       IPW_DEBUG_IO("%s %d: read_direct8(0x%08X)\n", __FILE__, __LINE__, \
>> +                       (u32)(ofs)); \
>> +       _ipw_read8(ipw, ofs); \
>> +})
> 
> Please put a do {} while(0) for this and some of below macros as well.

This is impossible, reads need to return a value...
