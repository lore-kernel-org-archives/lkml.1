Return-Path: <linux-kernel-owner+w=401wt.eu-S932411AbZKMVFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411AbZKMVFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 16:05:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932361AbZKMVFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 16:05:20 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:25401 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271AbZKMVFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 16:05:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=EEv+GrD1XNym4cOmucM4nQCNRKopt089vVLU4KZAVpBZ4zNU0TtVbfH0BEkSDSSskc
         HWyT5r3R4wG22QVIBntiKxXJ85XYblaywe7PNjZtkqZLS4Bn27e1ZY6ED0jqHAHHyO8B
         lJ4PdQnnmunYbAAgpdT9iw3dkfBH8+vS/PWME=
Message-ID: <4AFDCA0E.4080007@lwfinger.net>
Date: Fri, 13 Nov 2009 15:05:18 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de, Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 64-bit DMA problems with BCM4312 using b43
References: <4AFD958E.1000303@lwfinger.net> <20091113201112.GA5540@srcf.ucam.org> <200911132144.24110.mb@bu3sch.de>
In-Reply-To: <200911132144.24110.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2009 02:44 PM, Michael Buesch wrote:
> On Friday 13 November 2009 21:11:12 Matthew Garrett wrote:
>> On Fri, Nov 13, 2009 at 11:21:18AM -0600, Larry Finger wrote:
>>
>>> I do not know enough about either the ACPI or DMA code to begin debugging in
>>> either of those regions. Any suggestions on debugging strategies, or links to
>>> similar problems would be appreciated.
>>
>> Could the hardware be highly sensitive to DMA latencies? Take a look at 
>> the pm_qos code in ipw2100.
> 
> This makes perfect sense, yes. The DMA engine has so many quirks, I wouldn't be
> surprised if it couldn't handle pm properly.

I'm in the process of creating a patch to set the latency to 200 usec. The
default is 2000. On my fast prosessors, it should not be anything nearly that
slow. If we determine this to be the problem, then we can try tuning.

Larry
