Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935208Ab0BZE32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 23:29:28 -0500
Received: from mail-pz0-f194.google.com ([209.85.222.194]:58565 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935198Ab0BZE31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 23:29:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nOqlGwpvK215mPCaAPWJrm2gKHa7OkkXmQTg5KiMkvOGZ0NLquGTeZXuWTpeIR/Vb6
         aD/akxzMUa9aHwNovksw7zPF6XzSHtnXnrw40J1OFNI+338qbZhoITallKj77LltdEBr
         UBTDRT/PtFOE9kxmOC29WiZOIJyRM0qCdhYvE=
MIME-Version: 1.0
In-Reply-To: <20100225160344.GG30679@trinity.fluff.org>
References: <22dbbef21002250507s12664df5q36e50a8f9e0bc3b9@mail.gmail.com>
	 <20100225160344.GG30679@trinity.fluff.org>
Date: Fri, 26 Feb 2010 09:59:26 +0530
Message-ID: <22dbbef21002252029k54236940wf51e599a169e360e@mail.gmail.com>
Subject: Re: QUERY: How to call board specific initialization function before 
	map_io or timer_init
From: viresh kumar <viresh.linux@gmail.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       viresh.kumar@st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Situation: I need to register my clock framework with
>> arch/arm/common/clkdev framework
>> before actually initializing timer. So i can't do this in
>> "init_machine" as timer_init is called
>> before that.
>
> One method would be to use an init call from <linux/init.h> which is
> called before these are done (you'll have to work out which one is
> suitable for yourself).
>

I tried few of them but timer_init or map_io are getting called before my
routine is called.

> Either that or ensure that your boards always call a specific
> routine in their init sequence to ensure clocks are registered before
> the timer needs them.
>
> If I remeber correctly, map_io() is actually called before the timers
> are initialised, so you could add your clocks there.

I can add my init routine to map_io's implementation, but i think
map_io is not supposed to be implemented that way. map_io should
be called to statically map devices memory. It is not for hardware
specific initializations.

Is my understanding correct?


regards,
viresh kumar
