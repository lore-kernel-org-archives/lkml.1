Return-Path: <linux-kernel-owner+w=401wt.eu-S1754938AbYJMVl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbYJMVl3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 17:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754503AbYJMVlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 17:41:01 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:58875 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbYJMVlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 17:41:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Vfgeip+B6LMgwT2e/j26xCSEwqpNjqgNjsUfrVxEcEQRglRlv76sged2ympiLMrIdS
         erEF4L8/Ph5RkB9WNn/LWwbj1O6iCUx7ZkQphsIxTeMaonChihGBfAQnbV15CyNiMk7L
         hqsHQM/BHPM9Lt39d30jPI9nuI8RkfokeXimw=
Message-ID: <48F3C060.2050302@gmail.com>
Date: Mon, 13 Oct 2008 17:40:48 -0400
From: Robert William Fuller <hydrologiccycle@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080513)
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>,
       video4linux-list@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] video: simplify cx18_get_input() and	ivtv_get_input()
References: <48F3B56E.9050404@freemail.hu> <200810132328.47170.hverkuil@xs4all.nl>
In-Reply-To: <200810132328.47170.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans Verkuil wrote:
> On Monday 13 October 2008 22:54:06 Németh Márton wrote:
>> From: Márton Németh <nm127@freemail.hu>
>>
>> The cx18_get_input() and ivtv_get_input() are called
>> once from the VIDIOC_ENUMINPUT ioctl() and once from
>> the *_log_status() functions. In the first case the
>> struct v4l2_input is already filled with zeros,
>> so doing this again is unnecessary.
> 
> And in the second case no one cares whether the struct is zeroed. And 
> the same situation is also true for ivtv_get_output().

Yeah, 'cos there's nothing better than uninitialized fields, like the 
recent report of a control that returns minimum and maximum values of 
zero, but a step-size of 9.  Why are we optimizing code paths that are 
not performance critical by uninitializing memory?
