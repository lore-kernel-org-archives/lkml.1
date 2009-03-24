Return-Path: <linux-kernel-owner+w=401wt.eu-S1760664AbZCXNVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760664AbZCXNVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 09:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760275AbZCXNVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 09:21:38 -0400
Received: from dgate10.fujitsu-siemens.com ([80.70.172.49]:10588 "EHLO
	dgate10.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759745AbZCXNVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 09:21:37 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:X-IronPort-AV:
   Received:Received:Message-ID:Date:From:Organization:
   User-Agent:MIME-Version:To:CC:Subject:References:
   In-Reply-To:X-Enigmail-Version:Content-Type:
   Content-Transfer-Encoding;
  b=QNBtXQnZd/1zp/pj2tZqmaV92FFKVNclLh2Aj5PlDXumf8XAPiJV531f
   7hYCQGY3AbJHTt6BQOJw9M+oku3bczBuSocAkxda+SHIXAL7VzIxDFMbH
   AwDbZ99GvwljrFY;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.38,412,1233529200"; 
   d="scan'208";a="64815723"
X-IronPort-AV: E=Sophos;i="4.38,412,1233529200"; 
   d="scan'208";a="45481070"
Message-ID: <49C8DE5C.9050705@fujitsu-siemens.com>
Date: Tue, 24 Mar 2009 14:21:32 +0100
From: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Organization: Fujitsu Siemens Computers
User-Agent: Thunderbird 2.0.0.15pre (X11/20080508)
MIME-Version: 1.0
To: Corey Minyard <minyard@acm.org>
CC: Greg KH <greg@kroah.com>,
       "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Openipmi-developer] Improving IPMI performance under load
References: <49C27281.4040207@fujitsu-siemens.com> <49C2B994.7040808@acm.org> <20090319235114.GA18182@kroah.com> <49C3B6A5.5030408@acm.org> <20090320174701.GA14823@kroah.com> <49C3E03E.10506@acm.org> <49C78BE0.9090107@fujitsu-siemens.com> <49C7F368.5040304@acm.org> <49C8A823.6020809@fujitsu-siemens.com> <49C8DB54.4010200@acm.org>
In-Reply-To: <49C8DB54.4010200@acm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corey Minyard wrote:

> I would guess that changing the nice value is the main thing that caused 
> the difference.  The other changes probably didn't make as big a difference.

That's true, but setting the nice level to 0 isn't "nice" without 
kipmid_max_busy. The two parameters help to make sure that kipmid 
doesn't use excessive CPU time.

I am not sure about your reasons to call schedule() in every loop 
iteration. If there is no other process that needs to run, it will just 
waste cycles trying to figure that out. If there are other processes, 
you say yourself that "kipmid would never be scheduled in a
busy system". Does it really make sense to  call schedule() every 
microsecond? That's what kipmid effectively does if it waits for the KCS 
interface, because it'll do a port_inb() in every iteration which takes 
ca. 1us.

> I'm ok with tuning like this, but most users are probably not going to 
> want this type of behavior.

Let's wait and see :-)

Martin

-- 
Martin Wilck
PRIMERGY System Software Engineer
FSC IP ESP DEV 6

Fujitsu Siemens Computers GmbH
Heinz-Nixdorf-Ring 1
33106 Paderborn
Germany

Tel:			++49 5251 525 2796
Fax:			++49 5251 525 2820
Email:			mailto:martin.wilck@fujitsu-siemens.com
Internet:		http://www.fujitsu-siemens.com
Company Details:	http://www.fujitsu-siemens.com/imprint.html
