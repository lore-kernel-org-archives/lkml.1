Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbYGZBSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbYGZBSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 21:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbYGZBSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 21:18:44 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:31086 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752300AbYGZBSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 21:18:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xHtaVWx+3hI6NKjbJ9gGp44G6Q11jmfvDq9S69ECm1cTD1ySa141lqo7kFpMDwH9zvgRFbkpCvYeYrBMcftD1hkf2r040TEtVJphgfbaUz1DxXJ9pHsipq8qStc0DruPL5LilVgW84eU/7ogPJlsBWyNBr/po8Pr7TGTQqzS9WA=  ;
X-YMail-OSG: 0phjREkVM1kBFXn1sXqfMBjPOLWj4_27Td23RjTkJgQ4mjXR6J9Ie5b5zgG23Bxu_vjVh3h4sgIVGlGPxY5kt2Ur.z9OTAuhcP2oVbFRLw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [USB boot crash, -git] ecm_do_notify(), list_add corruption. prev->next should be next (ffff88003b8f82f8)
Date: Fri, 25 Jul 2008 18:18:22 -0700
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <Pine.LNX.4.44L0.0807240931220.3494-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0807240931220.3494-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200807251818.23046.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 July 2008, Alan Stern wrote:
> I think I see the problem.  Starting at line 533, we have:
> 
>        ...
> 
> The list_add_tail() gets called at the wrong time if the completion
> routine resubmits.  It should look more like this:
> 
>       ...
> 
> Can you make the necessary change and try it out?

It behaved for me, no BUG() ... I'll clean it up and send along a patch.

- Dave
